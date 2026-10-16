extends Node

# Autoload manager for persisting and loading game progression via JSON (user://savegame.json).
# Tracks the current level file path, player health, and elapsed game time across sessions.

const SAVE_PATH := "user://savegame.json"
const CURRENT_VERSION := 1

var is_loading_save: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

# Checks if a valid savegame file exists on disk with readable level data.
func has_save() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return false
	var data := load_game()
	return not data.is_empty() and data.has("level_path") and str(data["level_path"]) != ""

# Writes level path, player health, and elapsed time to user://savegame.json.
func save_game(level_path: String, health: int, elapsed_time: float) -> void:
	# Avoid saving menus or victory screens as continue targets
	var lower_path := level_path.to_lower()
	if lower_path.contains("win_screen") or lower_path.contains("main_menu") or lower_path.contains("game_over"):
		return

	# Resolve UID to file path if needed so saves always store full scene paths
	if level_path.begins_with("uid://"):
		var uid := ResourceUID.text_to_id(level_path)
		if ResourceUID.has_id(uid):
			level_path = ResourceUID.get_id_path(uid)

	var save_dict := {
		"version": CURRENT_VERSION,
		"level_path": level_path,
		"health": health,
		"elapsed_time": elapsed_time
	}

	var json_string := JSON.stringify(save_dict, "\t")
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(json_string)
		file.flush()
		file.close()
		print("[SaveManager] Game saved successfully: Level='%s', HP=%d, Time=%.1fs" % [level_path, health, elapsed_time])
	else:
		push_error("[SaveManager] Failed to write save file at " + SAVE_PATH)

# Helper to automatically capture and save the current game state from active scene nodes.
func save_current_game() -> void:
	var tree := get_tree()
	if tree == null or tree.current_scene == null:
		return
	
	var scene_path := tree.current_scene.scene_file_path
	var player := tree.get_first_node_in_group("player")
	var hp: int = player.health if (player and "health" in player) else 5
	var hud := tree.current_scene.get_node_or_null("HUD")
	var time: float = hud.elapsed_time if (hud and "elapsed_time" in hud) else 0.0

	save_game(scene_path, hp, time)

# Reads and parses user://savegame.json, returning an empty Dictionary if corrupt or missing.
func load_game() -> Dictionary:
	if not FileAccess.file_exists(SAVE_PATH):
		return {}

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not file:
		push_warning("[SaveManager] Could not open save file for reading.")
		return {}

	var content := file.get_as_text()
	file.close()

	var json := JSON.new()
	var error := json.parse(content)
	if error != OK:
		push_warning("[SaveManager] Corrupted save file JSON. Error code: %d" % error)
		return {}

	if typeof(json.data) != TYPE_DICTIONARY:
		push_warning("[SaveManager] Unexpected data structure in save file.")
		return {}

	print("[SaveManager] Game loaded from disk: ", json.data)
	return json.data

# Removes the save file from disk (called on victory or when starting a fresh game).
func delete_save() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var dir := DirAccess.open("user://")
		if dir and dir.file_exists("savegame.json"):
			dir.remove("savegame.json")
		if FileAccess.file_exists(SAVE_PATH):
			DirAccess.remove_absolute(SAVE_PATH)
		print("[SaveManager] Save file deleted.")

# Initiates a new game at Level-1, resetting player stats and replacing existing save.
func start_new_game() -> void:
	delete_save()
	var starting_level := "res://Playable Levels/Level-1.tscn"
	save_game(starting_level, 5, 0.0)
	get_tree().change_scene_to_file(starting_level)

# Continues game from saved data, transitioning to the level and restoring HP/timer.
func continue_game() -> void:
	var data := load_game()
	if data.is_empty() or not data.has("level_path"):
		push_warning("[SaveManager] No save data found to continue.")
		return

	var target_level: String = data["level_path"]
	is_loading_save = true

	var tree := get_tree()
	tree.change_scene_to_file(target_level)
	_apply_loaded_state(data)

# Waits for scene instantiation to complete before restoring health and HUD timer values.
func _apply_loaded_state(data: Dictionary) -> void:
	var tree := get_tree()
	if tree == null:
		return

	# Wait two process frames so the level, Player, and HUD run their _ready() calls
	await tree.process_frame
	await tree.process_frame

	var player := tree.get_first_node_in_group("player")
	var saved_hp: int = int(data.get("health", 5))
	if player:
		player.health = saved_hp
		if player.has_signal("health_changed"):
			player.health_changed.emit(saved_hp)
		print("[SaveManager] Restored player health to: %d" % saved_hp)

	var current_scene := tree.current_scene
	var hud := current_scene.get_node_or_null("HUD") if current_scene else null
	var saved_time: float = float(data.get("elapsed_time", 0.0))
	if hud:
		if hud.has_method("set_elapsed_time"):
			hud.set_elapsed_time(saved_time)
		elif "elapsed_time" in hud:
			hud.elapsed_time = saved_time
		if player and hud.has_method("update_health_display"):
			hud.update_health_display(player.health, player.max_health)
		print("[SaveManager] Restored HUD timer to: %.1fs" % saved_time)

	is_loading_save = false
