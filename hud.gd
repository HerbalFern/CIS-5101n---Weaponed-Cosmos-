extends CanvasLayer

# In-game HUD displaying player health hearts, current level name, and elapsed game time.

const HEART_FULL: Texture2D = preload("res://Sprites/UI/heart_full.png")
const HEART_EMPTY: Texture2D = preload("res://Sprites/UI/heart_empty.png")

@onready var hp_label: Label = %HPLabel
@onready var pips_container: HBoxContainer = %PipsContainer
@onready var level_label: Label = %LevelLabel
@onready var timer_label: Label = %TimerLabel

var player: CharacterBody2D
var elapsed_time: float = 0.0

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

func _setup_player() -> void:
	player = get_tree().get_first_node_in_group("player") as CharacterBody2D
	if player:
		if not player.health_changed.is_connected(_on_player_health_changed):
			player.health_changed.connect(_on_player_health_changed)
		update_health_display(player.health, player.max_health)
	else:
		# Retry next frame if player is still instantiating
		await get_tree().process_frame
		_setup_player()

func _on_player_health_changed(new_health: int) -> void:
	var max_hp: int = player.max_health if player else 5
	update_health_display(new_health, max_hp)

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
