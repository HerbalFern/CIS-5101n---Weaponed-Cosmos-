extends Area2D

@export var damage := 1

func _physics_process(_delta: float) -> void:
	var bodies := get_overlapping_bodies()
	if bodies.size() > 0:
		print("Spikes overlapping: ", bodies)
	for body in bodies:
		if body.has_method("take_damage"):
			body.take_damage(damage)
