extends Control

# Main Menu controller handling scene transitions, settings overlay, and game exit.
# Conditionally displays the Continue button when an active savegame is detected on disk.

@onready var title_label: Label = $CenterContainer/VBox/Title
@onready var continue_button: Button = %ContinueButton
@onready var start_button: Button = %StartButton
@onready var settings_button: Button = %SettingsButton
@onready var quit_button: Button = %QuitButton
@onready var settings_panel: Control = %SettingsPanel

func _ready() -> void:
	# Juice: Title entrance slide and button hover micro-animations
	Juice.slide_fade_in(title_label)
	Juice.setup_button_hover(continue_button)
	Juice.setup_button_hover(start_button)
	Juice.setup_button_hover(settings_button)
	Juice.setup_button_hover(quit_button)

	# Only show Continue if a savegame exists on disk
	if SaveManager.has_save():
		continue_button.show()
	else:
		continue_button.hide()

	# Hide settings by default
	if settings_panel:
		settings_panel.hide()
		settings_panel.back_pressed.connect(_on_settings_back)

	continue_button.pressed.connect(_on_continue_pressed)
	start_button.pressed.connect(_on_start_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

	# Apply accessibility font scaling
	Settings.apply_font_size(self)
	Settings.large_text_changed.connect(func(_val): Settings.apply_font_size(self))

# Continues game from the existing savegame progression.
func _on_continue_pressed() -> void:
	AudioManager.play_button_click()
	SaveManager.continue_game()

# Starts a fresh game session starting at Level-1 with reset health and timer.
func _on_start_pressed() -> void:
	AudioManager.play_button_click()
	SaveManager.start_new_game()

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
