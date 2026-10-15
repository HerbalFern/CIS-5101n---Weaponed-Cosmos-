extends CanvasLayer

# Pause menu overlay toggled via the 'pause' action (Escape key).
# Stops game tree execution while keeping UI responsive, saving state on exit to menu.

@onready var title_label: Label = $PauseControl/CenterContainer/VBox/Title
@onready var resume_button: Button = %ResumeButton
@onready var settings_button: Button = %SettingsButton
@onready var menu_button: Button = %MenuButton
@onready var settings_panel: Control = %SettingsPanel

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 20
	hide()

	if settings_panel:
		settings_panel.hide()
		settings_panel.back_pressed.connect(_on_settings_back)

	# Setup juice hover micro-animations on interactive buttons
	Juice.setup_button_hover(resume_button)
	Juice.setup_button_hover(settings_button)
	Juice.setup_button_hover(menu_button)

	resume_button.pressed.connect(_on_resume_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	menu_button.pressed.connect(_on_menu_pressed)

	Settings.apply_font_size(self)
	Settings.large_text_changed.connect(func(_val): Settings.apply_font_size(self))

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if visible:
			if settings_panel and settings_panel.visible:
				settings_panel.hide()
			else:
				resume_game()
		else:
			pause_game()
		get_viewport().set_input_as_handled()

# Pauses game tree and slides in the pause title banner.
func pause_game() -> void:
	AudioManager.play_button_click()
	Juice.reset_time_scale()
	get_tree().paused = true
	show()
	Juice.slide_fade_in(title_label)

# Unpauses game tree and hides overlay.
func resume_game() -> void:
	AudioManager.play_button_click()
	get_tree().paused = false
	hide()

func _on_resume_pressed() -> void:
	resume_game()

func _on_settings_pressed() -> void:
	AudioManager.play_button_click()
	if settings_panel:
		settings_panel.show()

func _on_settings_back() -> void:
	if settings_panel:
		settings_panel.hide()

# Automatically saves active gameplay progression before returning to Main Menu.
func _on_menu_pressed() -> void:
	AudioManager.play_button_click()
	SaveManager.save_current_game()
	get_tree().paused = false
	Juice.reset_time_scale()
	get_tree().change_scene_to_file("res://main_menu.tscn")
