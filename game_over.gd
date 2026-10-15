extends CanvasLayer

# Game Over overlay shown when player health reaches zero.
# Pauses the game tree and offers restart or main menu options with polished UI animations.

@onready var title_label: Label = $GameOverControl/CenterContainer/VBox/Title
@onready var restart_button: Button = %RestartButton
@onready var menu_button: Button = %MenuButton

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 25
	get_tree().paused = true
	Juice.reset_time_scale()

	# Juice: Title entrance slide and hover animations on interactive buttons
	Juice.slide_fade_in(title_label)
	Juice.setup_button_hover(restart_button)
	Juice.setup_button_hover(menu_button)

	restart_button.pressed.connect(_on_restart_pressed)
	menu_button.pressed.connect(_on_menu_pressed)

	Settings.apply_font_size(self)
	Settings.large_text_changed.connect(func(_val): Settings.apply_font_size(self))

func _on_restart_pressed() -> void:
	AudioManager.play_button_click()
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_menu_pressed() -> void:
	AudioManager.play_button_click()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu.tscn")
