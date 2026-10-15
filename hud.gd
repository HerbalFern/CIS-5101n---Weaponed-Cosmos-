extends CanvasLayer

# In-game HUD displaying player health hearts, current level name, and elapsed game time.
# Includes tweened heart-pop animations on damage/healing and savegame timer integration.

const HEART_FULL: Texture2D = preload("res://Sprites/UI/heart_full.png")
const HEART_EMPTY: Texture2D = preload("res://Sprites/UI/heart_empty.png")

@onready var hp_label: Label = %HPLabel
@onready var pips_container: HBoxContainer = %PipsContainer
@onready var level_label: Label = %LevelLabel
@onready var timer_label: Label = %TimerLabel

var player: CharacterBody2D
var elapsed_time: float = 0.0
var _previous_health: int = -1

func _ready() -> void:
	layer = 10
	
	# Determine current level name based on scene file name
	var file_name: String = get_tree().current_scene.scene_file_path.get_file().get_basename() if get_tree().current_scene else ""
	if file_name != "":
		level_label.text = file_name.replace("-", " ")
	else:
		level_label.text = "Weaponed Cosmos"

	# Apply font scaling for accessibility
	Settings.apply_font_size(self)
	Settings.large_text_changed.connect(func(_val): Settings.apply_font_size(self))

	# Connect to player with retry mechanism if not ready immediately
	_setup_player.call_deferred()

func _process(delta: float) -> void:
	elapsed_time += delta
	var minutes := floori(elapsed_time / 60.0)
	var seconds := int(elapsed_time) % 60
	timer_label.text = "%02d:%02d" % [minutes, seconds]

# Sets the elapsed timer starting point (used when restoring saved games).
func set_elapsed_time(time_sec: float) -> void:
	elapsed_time = max(time_sec, 0.0)
	var minutes := floori(elapsed_time / 60.0)
	var seconds := int(elapsed_time) % 60
	timer_label.text = "%02d:%02d" % [minutes, seconds]

func _setup_player() -> void:
	player = get_tree().get_first_node_in_group("player") as CharacterBody2D
	if player:
		if not player.health_changed.is_connected(_on_player_health_changed):
			player.health_changed.connect(_on_player_health_changed)
		update_health_display(player.health, player.max_health)
		
		# If loading a level for the first time without an active save, save initial state
		if not SaveManager.is_loading_save and not SaveManager.has_save():
			SaveManager.save_current_game()
	else:
		# Retry next frame if player is still instantiating
		await get_tree().process_frame
		_setup_player()

func _on_player_health_changed(new_health: int) -> void:
	var max_hp: int = player.max_health if player else 5
	update_health_display(new_health, max_hp)

# Updates heart icons and triggers an impactful scale-pop on the altered heart pip.
func update_health_display(current_hp: int, max_hp: int) -> void:
	current_hp = clampi(current_hp, 0, max_hp)
	hp_label.text = "HP: %d/%d" % [current_hp, max_hp]
	
	# Ensure correct number of heart TextureRects exist
	while pips_container.get_child_count() < max_hp:
		var heart_rect := TextureRect.new()
		heart_rect.custom_minimum_size = Vector2(16, 16)
		heart_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		heart_rect.texture = HEART_FULL
		pips_container.add_child(heart_rect)
	
	# Update visual hearts (full vs empty)
	for i in range(pips_container.get_child_count()):
		var heart: TextureRect = pips_container.get_child(i) as TextureRect
		if heart:
			if i < current_hp:
				heart.texture = HEART_FULL
			else:
				heart.texture = HEART_EMPTY

	# Pop the changed heart using a springy back-out tween
	if _previous_health != -1 and _previous_health != current_hp:
		var pop_idx := current_hp if current_hp < _previous_health else (current_hp - 1)
		pop_idx = clampi(pop_idx, 0, pips_container.get_child_count() - 1)
		var target_heart: TextureRect = pips_container.get_child(pop_idx) as TextureRect
		if target_heart:
			_pop_heart(target_heart)

	_previous_health = current_hp

# Bounces the heart up to 1.4x scale and returns smoothly to normal size.
func _pop_heart(heart: TextureRect) -> void:
	if heart == null:
		return
	heart.pivot_offset = heart.size / 2.0 if heart.size != Vector2.ZERO else Vector2(8, 8)
	var tween := create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	heart.scale = Vector2(1.4, 1.4)
	tween.tween_property(heart, "scale", Vector2.ONE, 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
