extends Area2D

# Transition door leading to the next level or ending screen.
# Automatically persists player HP, timer, and next level destination to SaveManager.

@export_file("*.tscn") var next_level: String

func _ready() -> void:
	body_entered.connect(_on_body_entered)

# Handles player arrival at door: plays transition SFX, saves progression, and loads next level.
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player") and next_level != "":
		AudioManager.play_door()

		# Resolve UID to full scene path if door uses a uid:// reference
		var target_scene := next_level
		if target_scene.begins_with("uid://"):
			var uid := ResourceUID.text_to_id(target_scene)
			if ResourceUID.has_id(uid):
				target_scene = ResourceUID.get_id_path(uid)

		# Save progression for the upcoming level (unless progressing to win screen)
		if not target_scene.to_lower().contains("win_screen"):
			var player_hp: int = body.health if "health" in body else 5
			var hud := get_tree().current_scene.get_node_or_null("HUD") if get_tree().current_scene else null
			var current_time: float = hud.elapsed_time if (hud and "elapsed_time" in hud) else 0.0
			SaveManager.save_game(target_scene, player_hp, current_time)

		get_tree().change_scene_to_file.call_deferred(next_level)
