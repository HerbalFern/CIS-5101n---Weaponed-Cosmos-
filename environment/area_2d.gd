extends Area2D

func _on_body_entered(body: Node) -> void:
		if body.name == "player":
			print("hit")
			$AudioStreamPlayer2D.play()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
