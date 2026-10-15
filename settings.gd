extends Node

# Settings manager handling player preferences and accessibility options.
# Automatically persists settings to user://settings.cfg.

signal large_text_changed(is_large: bool)

const CONFIG_PATH := "user://settings.cfg"
var ui_theme: Theme

var large_text: bool = false:
	set(value):
		if large_text != value:
			large_text = value
			update_theme_font_size()
			save_settings()
			large_text_changed.emit(large_text)

func _ready() -> void:
	if ResourceLoader.exists("res://ui_theme.tres"):
		ui_theme = load("res://ui_theme.tres")
	load_settings()
	update_theme_font_size()

# Updates the global UI theme default font size according to large_text
func update_theme_font_size() -> void:
	if ui_theme:
		ui_theme.default_font_size = 24 if large_text else 16

# Loads saved settings from disk, applying defaults if file doesn't exist
func load_settings() -> void:
	var config := ConfigFile.new()
	var err := config.load(CONFIG_PATH)
	if err == OK:
		large_text = config.get_value("accessibility", "large_text", false)
	else:
		large_text = false

# Saves current settings to disk
func save_settings() -> void:
	var config := ConfigFile.new()
	config.set_value("accessibility", "large_text", large_text)
	config.save(CONFIG_PATH)

# Helper function to apply font sizing dynamically to any Control and all its children
func apply_font_size(node: Node, normal_size: int = 16, large_size: int = 24) -> void:
	var target_size := large_size if large_text else normal_size
	if node is Label or node is Button or node is CheckButton or node is CheckBox:
		node.add_theme_font_size_override("font_size", target_size)
	for child in node.get_children():
		apply_font_size(child, normal_size, large_size)
