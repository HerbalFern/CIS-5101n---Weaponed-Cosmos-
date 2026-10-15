extends Control

# Reusable settings panel for audio volume, mute toggles, and accessibility text sizing.

signal back_pressed

@onready var master_slider: HSlider = %MasterSlider
@onready var master_mute: CheckBox = %MasterMute
@onready var music_slider: HSlider = %MusicSlider
@onready var music_mute: CheckBox = %MusicMute
@onready var sfx_slider: HSlider = %SFXSlider
@onready var sfx_mute: CheckBox = %SFXMute
@onready var large_text_btn: CheckButton = %LargeTextButton
@onready var back_btn: Button = %BackButton

var master_idx: int = 0
var music_idx: int = 1
var sfx_idx: int = 2

func _ready() -> void:
	# Get bus indices dynamically by name
	master_idx = AudioServer.get_bus_index("Master")
	music_idx = AudioServer.get_bus_index("Music")
	sfx_idx = AudioServer.get_bus_index("SFX")

	# Initialize sliders and mute checkboxes from current bus state
	if master_slider:
		master_slider.value = db_to_linear(AudioServer.get_bus_volume_db(master_idx))
		master_slider.value_changed.connect(_on_master_slider_changed)
	if master_mute:
		master_mute.button_pressed = AudioServer.is_bus_mute(master_idx)
		master_mute.toggled.connect(_on_master_mute_toggled)

	if music_slider:
		music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(music_idx))
		music_slider.value_changed.connect(_on_music_slider_changed)
	if music_mute:
		music_mute.button_pressed = AudioServer.is_bus_mute(music_idx)
		music_mute.toggled.connect(_on_music_mute_toggled)

	if sfx_slider:
		sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_idx))
		sfx_slider.value_changed.connect(_on_sfx_slider_changed)
	if sfx_mute:
		sfx_mute.button_pressed = AudioServer.is_bus_mute(sfx_idx)
		sfx_mute.toggled.connect(_on_sfx_mute_toggled)

	# Accessibility toggle
	if large_text_btn:
		large_text_btn.button_pressed = Settings.large_text
		large_text_btn.toggled.connect(_on_large_text_toggled)

	if back_btn:
		back_btn.pressed.connect(_on_back_pressed)

	# Apply font scaling dynamically
	Settings.apply_font_size(self)
	Settings.large_text_changed.connect(func(_val): Settings.apply_font_size(self))

func _on_master_slider_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(master_idx, linear_to_db(value))

func _on_master_mute_toggled(toggled_on: bool) -> void:
	AudioManager.play_button_click()
	AudioServer.set_bus_mute(master_idx, toggled_on)

func _on_music_slider_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(music_idx, linear_to_db(value))

func _on_music_mute_toggled(toggled_on: bool) -> void:
	AudioManager.play_button_click()
	AudioServer.set_bus_mute(music_idx, toggled_on)

func _on_sfx_slider_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(sfx_idx, linear_to_db(value))

func _on_sfx_mute_toggled(toggled_on: bool) -> void:
	AudioManager.play_button_click()
	AudioServer.set_bus_mute(sfx_idx, toggled_on)

func _on_large_text_toggled(toggled_on: bool) -> void:
	AudioManager.play_button_click()
	Settings.large_text = toggled_on

func _on_back_pressed() -> void:
	AudioManager.play_button_click()
	back_pressed.emit()
	hide()
