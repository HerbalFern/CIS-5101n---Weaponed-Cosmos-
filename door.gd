extends Area2D

@export_file("*.tscn") var next_level: String

func _ready() -> void:
	print("Door ready")
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	print("Door touched by: ", body.name)
	print("In player group? ", body.is_in_group("player"))
	print("next_level = '", next_level, "'")
	if body.is_in_group("player") and next_level != "":
		AudioManager.play_door()
		get_tree().change_scene_to_file.call_deferred(next_level)
