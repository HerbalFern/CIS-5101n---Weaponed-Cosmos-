extends Area2D

const SPEED := 300.0
var direction := Vector2.RIGHT

func _ready() -> void:
	rotation = direction.angle()
	body_entered.connect(_on_body_entered)
	await get_tree().create_timer(1.5).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	position += direction * SPEED * delta

func _on_body_entered(body: Node) -> void:
	if body.has_method("take_damage"):
		body.take_damage(1)
	queue_free()
