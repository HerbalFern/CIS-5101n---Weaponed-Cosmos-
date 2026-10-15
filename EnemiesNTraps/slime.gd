extends CharacterBody2D

# ── Finite State Machine ─────────────────────────────────────────────────────
enum State { IDLE, CHASE, ATTACK, HURT, DEAD }

const DAMAGE_PARTICLES := preload("res://Particles/enemy_damage_particles.tscn")

# ── Exports ──────────────────────────────────────────────────────────────────
@export var health: int         = 3
@export var detect_range: float = 120.0
@export var attack_range: float = 14.0
@export var chase_speed: float  = 40.0
@export var attack_damage: int  = 1
@export var attack_cooldown: float = 0.8

# ── State vars ───────────────────────────────────────────────────────────────
var _state: State = State.IDLE
var _attack_timer: float = 0.0
var _hurt_timer: float   = 0.0
const HURT_DURATION := 0.25

var player: Node2D = null

@onready var sprite: Sprite2D       = $Sprite2D
@onready var anim: AnimationPlayer  = $AnimationPlayer
@onready var hitbox: Area2D         = $Hitbox

# ── Lifecycle ─────────────────────────────────────────────────────────────────
func _ready() -> void:
	anim.play("Idle")

func _physics_process(delta: float) -> void:
	if player == null:
		player = get_tree().get_first_node_in_group("player")
		if player == null:
			return

	match _state:
		State.IDLE:   _state_idle()
		State.CHASE:  _state_chase()
		State.ATTACK: _state_attack(delta)
		State.HURT:   _state_hurt(delta)
		State.DEAD:   pass

# ── States ────────────────────────────────────────────────────────────────────
func _state_idle() -> void:
	velocity = Vector2.ZERO
	move_and_slide()
	if _dist_to_player() < detect_range:
		_enter_chase()

func _state_chase() -> void:
	var dist := _dist_to_player()
	if dist >= detect_range:
		_enter_idle()
		return
	if dist <= attack_range:
		_enter_attack()
		return
	var dir := (player.global_position - global_position).normalized()
	velocity = dir * chase_speed
	if dir.x != 0.0:
		sprite.flip_h = dir.x < 0.0
	move_and_slide()

func _state_attack(delta: float) -> void:
	velocity = Vector2.ZERO
	move_and_slide()
	_attack_timer -= delta
	if _attack_timer <= 0.0:
		_attack_timer = attack_cooldown
		if _dist_to_player() <= attack_range + 4.0:
			player.take_damage(attack_damage)
	if _dist_to_player() > attack_range + 8.0:
		_enter_chase()

func _state_hurt(delta: float) -> void:
	velocity = Vector2.ZERO
	move_and_slide()
	_hurt_timer -= delta
	if _hurt_timer <= 0.0:
		if health > 0:
			_enter_chase()

# ── Transitions ───────────────────────────────────────────────────────────────
func _enter_idle() -> void:
	_state = State.IDLE
	anim.play("Idle")

func _enter_chase() -> void:
	_state = State.CHASE
	anim.play("Idle")

func _enter_attack() -> void:
	_state = State.ATTACK
	_attack_timer = 0.0
	anim.play("Idle")

func _enter_hurt() -> void:
	_state = State.HURT
	_hurt_timer = HURT_DURATION
	var tween := create_tween()
	modulate = Color(3.0, 3.0, 3.0)
	tween.tween_property(self, "modulate", Color.WHITE, HURT_DURATION)

# ── Public API ────────────────────────────────────────────────────────────────
func take_damage(amount: int) -> void:
	if _state == State.DEAD:
		return
	health -= amount
	if health <= 0:
		AudioManager.play_enemy_death()
	else:
		AudioManager.play_enemy_hit()
	var particles := DAMAGE_PARTICLES.instantiate()
	particles.global_position = global_position
	get_tree().current_scene.add_child(particles)
	if health <= 0:
		_state = State.DEAD
		queue_free()
		return
	_enter_hurt()

# ── Utility ───────────────────────────────────────────────────────────────────
func _dist_to_player() -> float:
	if player == null:
		return INF
	return global_position.distance_to(player.global_position)
