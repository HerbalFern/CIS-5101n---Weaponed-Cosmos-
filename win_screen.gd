extends Control

# Victory screen displayed upon completing the final level.

@onready var play_again_button: Button = %PlayAgainButton
@onready var menu_button: Button = %MenuButton

func _ready() -> void:
	play_again_button.pressed.connect(_on_play_again_pressed)
	menu_button.pressed.connect(_on_menu_pressed)
	
	Settings.apply_font_size(self)
	Settings.large_text_changed.connect(func(_val): Settings.apply_font_size(self))

func _on_play_again_pressed() -> void:
	AudioManager.play_button_click()
	get_tree().change_scene_to_file("res://Playable Levels/Level-1.tscn")

func _on_menu_pressed() -> void:
	AudioManager.play_button_click()
	get_tree().change_scene_to_file("res://main_menu.tscn")
