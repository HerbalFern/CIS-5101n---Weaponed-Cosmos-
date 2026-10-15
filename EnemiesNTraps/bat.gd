extends CharacterBody2D

# ── Finite State Machine ─────────────────────────────────────────────────────
# Bat enemy – faster than slime, does a swooping dive-attack
# States: PATROL → CHASE → DIVE → HURT → DEAD
enum State { PATROL, CHASE, DIVE, HURT, DEAD }

const DAMAGE_PARTICLES := preload("res://Particles/enemy_damage_particles.tscn")

# ── Exports ───────────────────────────────────────────────────────────────────
@export var health: int            = 2
@export var detect_range: float    = 140.0
@export var patrol_speed: float    = 30.0
@export var chase_speed: float     = 70.0
@export var dive_speed: float      = 130.0
@export var dive_range: float      = 70.0   # triggers dive
@export var attack_damage: int     = 1
@export var dive_cooldown: float   = 1.5

# ── Internal state ────────────────────────────────────────────────────────────
var _state: State          = State.PATROL
var _patrol_dir: Vector2   = Vector2.RIGHT
var _patrol_timer: float   = 0.0
var _dive_duration: float  = 0.0
var _dive_cooldown_timer: float = 0.0
var _hurt_timer: float     = 0.0
const HURT_DURATION        := 0.2
const PATROL_FLIP_TIME     := 1.8   # seconds before reversing patrol direction

var player: Node2D = null
var _dive_target: Vector2  = Vector2.ZERO
var _hit_during_dive: bool = false

@onready var sprite: Sprite2D       = $Sprite2D
@onready var anim: AnimationPlayer  = $AnimationPlayer
@onready var hitbox: Area2D         = $Hitbox

# ── Lifecycle ─────────────────────────────────────────────────────────────────
func _ready() -> void:
	if anim and anim.has_animation("Flap"):
		anim.play("Flap")
	_patrol_dir = [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN].pick_random()
	if hitbox:
		hitbox.body_entered.connect(_on_hitbox_body_entered)

func _physics_process(delta: float) -> void:
	if _dive_cooldown_timer > 0.0:
		_dive_cooldown_timer -= delta

	if player == null or not is_instance_valid(player):
		player = get_tree().get_first_node_in_group("player")
		if player == null:
			return

	match _state:
		State.PATROL: _state_patrol(delta)
		State.CHASE:  _state_chase(delta)
		State.DIVE:   _state_dive(delta)
		State.HURT:   _state_hurt(delta)
		State.DEAD:   pass

# ── States ────────────────────────────────────────────────────────────────────
func _state_patrol(delta: float) -> void:
	_patrol_timer -= delta
	if _patrol_timer <= 0.0:
		_patrol_timer = PATROL_FLIP_TIME
		_patrol_dir = -_patrol_dir   # reverse
	velocity = _patrol_dir * patrol_speed
	move_and_slide()
	if velocity.x != 0.0:
		sprite.flip_h = velocity.x < 0.0
	if _dist_to_player() < detect_range:
		_enter_chase()

func _state_chase(delta: float) -> void:
	var dist := _dist_to_player()
	if dist >= detect_range:
		_enter_patrol()
		return
	if dist <= dive_range and _dive_cooldown_timer <= 0.0:
		_enter_dive()
		return
	var dir := (player.global_position - global_position).normalized()
	velocity = dir * chase_speed
	if dir.x != 0.0:
		sprite.flip_h = dir.x < 0.0
	move_and_slide()

func _state_dive(delta: float) -> void:
	# Rush toward the locked dive target
	var dir := (_dive_target - global_position).normalized()
	velocity = dir * dive_speed
	if dir.x != 0.0:
		sprite.flip_h = dir.x < 0.0
	move_and_slide()

	# Deal damage on contact during dive (once)
	if not _hit_during_dive:
		if global_position.distance_to(player.global_position) <= 22.0 or (hitbox and hitbox.overlaps_body(player)):
			if player.has_method("take_damage"):
				player.take_damage(attack_damage)
			_hit_during_dive = true

	# End dive when close to target or duration expires
	_dive_duration -= delta
	if _dive_duration <= 0.0 or global_position.distance_to(_dive_target) < 8.0:
		_dive_cooldown_timer = dive_cooldown
		_enter_chase()

func _state_hurt(delta: float) -> void:
	velocity = Vector2.ZERO
	move_and_slide()
	_hurt_timer -= delta
	if _hurt_timer <= 0.0 and health > 0:
		_enter_chase()

# ── Transitions ───────────────────────────────────────────────────────────────
func _enter_patrol() -> void:
	_state = State.PATROL
	_patrol_timer = PATROL_FLIP_TIME * 0.5
	if anim and anim.has_animation("Flap"):
		anim.play("Flap")

func _enter_chase() -> void:
	_state = State.CHASE
	if anim and anim.has_animation("Flap"):
		anim.play("Flap")

func _enter_dive() -> void:
	_state = State.DIVE
	_dive_duration = 0.6   # max dive duration
	_dive_target = player.global_position
	_hit_during_dive = false
	if anim and anim.has_animation("Flap"):
		anim.play("Flap")

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
		if AudioManager:
			AudioManager.play_enemy_death()
		Juice.shake(5.0, 0.2)
	else:
		if AudioManager:
			AudioManager.play_enemy_hit()
		Juice.shake(2.0, 0.1)
		Juice.hit_stop(0.03)
	if DAMAGE_PARTICLES:
		var particles := DAMAGE_PARTICLES.instantiate()
		particles.global_position = global_position
		get_tree().current_scene.add_child(particles)
	if health <= 0:
		_state = State.DEAD
		queue_free()
		return
	_enter_hurt()

func _on_hitbox_body_entered(body: Node) -> void:
	if body == player or (body is Node2D and body.is_in_group("player")):
		if not _hit_during_dive and _state == State.DIVE:
			if body.has_method("take_damage"):
				body.take_damage(attack_damage)
			_hit_during_dive = true

# ── Utility ───────────────────────────────────────────────────────────────────
func _dist_to_player() -> float:
	if player == null or not is_instance_valid(player):
		return INF
	return global_position.distance_to(player.global_position)
