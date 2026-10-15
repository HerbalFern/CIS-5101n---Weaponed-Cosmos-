extends Control

# Victory screen displayed upon completing the final level.
# Deletes save data upon arrival, features a celebratory bounce-in title, and offers restart.

@onready var title_label: Label = $CenterContainer/VBox/Title
@onready var play_again_button: Button = %PlayAgainButton
@onready var menu_button: Button = %MenuButton

func _ready() -> void:
	# Delete save file so game cannot be continued after winning
	SaveManager.delete_save()
	Juice.reset_time_scale()

	# Juice: Playful bounce-in animation for victory title banner
	Juice.bounce_in(title_label)

	# Juice: Button hover feedback
	Juice.setup_button_hover(play_again_button)
	Juice.setup_button_hover(menu_button)

	play_again_button.pressed.connect(_on_play_again_pressed)
	menu_button.pressed.connect(_on_menu_pressed)

	Settings.apply_font_size(self)
	Settings.large_text_changed.connect(func(_val): Settings.apply_font_size(self))

func _on_play_again_pressed() -> void:
	AudioManager.play_button_click()
	SaveManager.start_new_game()

func _on_menu_pressed() -> void:
	AudioManager.play_button_click()
	get_tree().change_scene_to_file("res://main_menu.tscn")
