extends CharacterBody2D

const SPEED := 120.0
const BULLET := preload("res://bullet.tscn")
const FIRE_DELAY := 0.25

var facing := Vector2.DOWN
var can_shoot := true

@onready var muzzle: Marker2D = $Muzzle

func _physics_process(_delta: float) -> void:
	var dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")

	# Snap facing to 4 directions, Zelda-style
	if dir != Vector2.ZERO:
		if abs(dir.x) > abs(dir.y):
			facing = Vector2(sign(dir.x), 0)
		else:
			facing = Vector2(0, sign(dir.y))

	velocity = dir * SPEED
	move_and_slide()

	muzzle.position = facing * 12

	if Input.is_action_pressed("shoot") and can_shoot:
		shoot()

func shoot() -> void:
	can_shoot = false
	var bullet := BULLET.instantiate()
	bullet.global_position = muzzle.global_position
	bullet.direction = facing
	get_tree().current_scene.add_child(bullet)
	await get_tree().create_timer(FIRE_DELAY).timeout
	can_shoot = true
