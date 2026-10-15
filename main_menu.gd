extends Control

# Main Menu controller handling scene transitions, settings overlay, and game exit.

@onready var start_button: Button = %StartButton
@onready var settings_button: Button = %SettingsButton
@onready var quit_button: Button = %QuitButton
@onready var settings_panel: Control = %SettingsPanel

func _ready() -> void:
	# Hide settings by default
	if settings_panel:
		settings_panel.hide()
		settings_panel.back_pressed.connect(_on_settings_back)

	start_button.pressed.connect(_on_start_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

	# Apply accessibility font scaling
	Settings.apply_font_size(self)
	Settings.large_text_changed.connect(func(_val): Settings.apply_font_size(self))

func _on_start_pressed() -> void:
	AudioManager.play_button_click()
	get_tree().change_scene_to_file("res://Playable Levels/Level-1.tscn")

func _on_settings_pressed() -> void:
	AudioManager.play_button_click()
	if settings_panel:
		settings_panel.show()

func _on_settings_back() -> void:
	if settings_panel:
		settings_panel.hide()

func _on_quit_pressed() -> void:
	AudioManager.play_button_click()
	get_tree().quit()
