extends CharacterBody2D

const SPEED := 20.0

@export var health := 3
@export var detect_range := 120.0

var player: Node2D

@onready var hitbox: Area2D = $Hitbox

#func _ready() -> void:
#	player = get_tree().get_first_node_in_group("player")

func _physics_process(_delta: float) -> void:
	if player == null:
		player = get_tree().get_first_node_in_group("player")
		return

	# Chase the player if close enough, otherwise stand still
	var to_player := player.global_position - global_position
	var dist := to_player.length()
	if dist < detect_range and dist > 10.0:
		velocity = to_player.normalized() * SPEED
	else:
		velocity = Vector2.ZERO
	move_and_slide()

	# Hurt the player while touching them
	for body in hitbox.get_overlapping_bodies():
		if body.is_in_group("player"):
			body.take_damage(1)

func take_damage(amount: int) -> void:
	print("Slime hit! health = ", health - amount)
	health -= amount
	if health <= 0:
		queue_free()
		return
	# Quick red flash so hits feel good
	var tween := create_tween()
	modulate = Color(3, 3, 3)
	tween.tween_property(self, "modulate", Color.WHITE, 0.15)
