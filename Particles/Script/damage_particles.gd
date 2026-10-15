extends CPUParticles2D

func _ready() -> void:
	emitting = true
	if not finished.is_connected(queue_free):
		finished.connect(queue_free)
	var timeout_duration := lifetime + 0.2
	get_tree().create_timer(timeout_duration).timeout.connect(func():
		if is_instance_valid(self):
			queue_free()
	)
