extends Node

# Autoload manager for background music and sound effects.
# Routes music to the "Music" bus and SFX to the "SFX" bus.
# Exported slots allow dragging audio files in the Godot inspector.

@export_group("Music")
@export var bgm_music: AudioStream

@export_group("Sound Effects")
@export var sfx_shoot: AudioStream
@export var sfx_player_hurt: AudioStream
@export var sfx_enemy_hit: AudioStream
@export var sfx_enemy_death: AudioStream
@export var sfx_button_click: AudioStream
@export var sfx_door: AudioStream

var music_player: AudioStreamPlayer

func _ready() -> void:
	# Persistent music player on the Music bus
	music_player = AudioStreamPlayer.new()
	music_player.bus = &"Music"
	add_child(music_player)
	
	# Loop music automatically when finished
	music_player.finished.connect(func():
		if music_player.stream != null:
			music_player.play()
	)
	
	if bgm_music != null:
		play_music(bgm_music)

# Plays a background music stream
func play_music(stream: AudioStream) -> void:
	if stream == null or music_player == null:
		return
	if music_player.stream == stream and music_player.playing:
		return
	music_player.stream = stream
	music_player.play()

# Stops background music playback
func stop_music() -> void:
	if music_player != null:
		music_player.stop()

# Helper to play a one-shot sound on the SFX bus without cutting off overlapping sounds
func play_sfx(stream: AudioStream) -> void:
	if stream == null:
		return
	var sfx_player := AudioStreamPlayer.new()
	sfx_player.stream = stream
	sfx_player.bus = &"SFX"
	add_child(sfx_player)
	sfx_player.finished.connect(sfx_player.queue_free)
	sfx_player.play()

# Dedicated SFX triggers (guarded with null checks)
func play_shoot() -> void:
	play_sfx(sfx_shoot)

func play_player_hurt() -> void:
	play_sfx(sfx_player_hurt)

func play_enemy_hit() -> void:
	play_sfx(sfx_enemy_hit)

func play_enemy_death() -> void:
	play_sfx(sfx_enemy_death)

func play_button_click() -> void:
	play_sfx(sfx_button_click)

func play_door() -> void:
	play_sfx(sfx_door)
