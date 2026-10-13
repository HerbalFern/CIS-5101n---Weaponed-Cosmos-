extends CharacterBody2D



signal health_changed(new_health)

const SPEED := 90.0
const BULLET := preload("res://Particles/bullet.tscn")

@export var fire_delay := 0.25
@export var max_health := 5

var health := 5
var facing := Vector2.DOWN
var can_shoot := true
var was_colliding := false
var invincible := false

@onready var muzzle: Marker2D = $Muzzle
@onready var bump: AudioStreamPlayer2D = $BumpSound

func _ready() -> void:
	add_to_group("player")
	health = max_health

func _physics_process(_delta: float) -> void:
	var dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if dir != Vector2.ZERO:
		if abs(dir.x) > abs(dir.y):
			facing = Vector2(sign(dir.x), 0)
		else:
			facing = Vector2(0, sign(dir.y))

	velocity = dir * SPEED
	move_and_slide()

	# Play the bump sound once when you start hitting something
	var hit := get_slide_collision_count() > 0
	if hit and not was_colliding:
		bump.play()
	was_colliding = hit

	muzzle.position = facing * 10

	# Only shoot while standing still
	if Input.is_action_pressed("shoot") and can_shoot and dir == Vector2.ZERO:
		shoot()

func shoot() -> void:
	can_shoot = false
	var bullet := BULLET.instantiate()
	bullet.global_position = muzzle.global_position
	bullet.direction = facing
	get_tree().current_scene.add_child(bullet)
	await get_tree().create_timer(fire_delay).timeout
	can_shoot = true

func take_damage(amount: int) -> void:
	if invincible:
		return
	invincible = true
	health -= amount
	health_changed.emit(health)
	print("Player hit! health = ", health)

	if health <= 0:
		get_tree().reload_current_scene()
		return

	# Blink, then 1 second of invincibility
	var tween := create_tween().set_loops(5)
	tween.tween_property($Sprite2D, "modulate:a", 0.3, 0.1)
	tween.tween_property($Sprite2D, "modulate:a", 1.0, 0.1)
	await get_tree().create_timer(1.0).timeout
	invincible = false

	
