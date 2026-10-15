extends Node

# Autoload manager providing "juice" (visual and physical feedback):
# 1. Screen shake via Camera2D offset tweening.
# 2. Hit-stop (momentary time freeze on impacts).
# 3. Micro-animation helpers for UI buttons and titles.

var _shake_tween: Tween
var _hit_stop_active: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

# Shakes the active 2D camera by jittering its offset with decaying random displacements.
# If a shake is already running, cancels it and restarts cleanly without stacking.
func shake(strength: float = 4.0, duration: float = 0.15) -> void:
	var viewport := get_viewport()
	if viewport == null:
		return
	var camera := viewport.get_camera_2d()
	if camera == null:
		return

	# Stop any currently active shake and reset camera back to base position
	if _shake_tween and _shake_tween.is_valid():
		_shake_tween.kill()
		camera.offset = Vector2.ZERO

	_shake_tween = create_tween()
	_shake_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)

	# Break duration into discrete micro-steps that decay in amplitude
	var steps := int(max(duration / 0.03, 3))
	var step_time := duration / float(steps)

	for i in range(steps):
		var decay := 1.0 - (float(i) / float(steps))
		var random_offset := Vector2(
			randf_range(-strength, strength) * decay,
			randf_range(-strength, strength) * decay
		)
		_shake_tween.tween_property(camera, "offset", random_offset, step_time)

	# Always return camera offset precisely to zero at the end
	_shake_tween.tween_property(camera, "offset", Vector2.ZERO, 0.02)

# Briefly reduces Engine.time_scale to create an impactful freeze frame on heavy hits.
# Uses an unscaled timer (ignore_time_scale = true) to restore normal speed in real time.
func hit_stop(duration: float = 0.05) -> void:
	# Ensure clean state if another hit occurs during an existing freeze
	Engine.time_scale = 0.05
	_hit_stop_active = true

	var tree := get_tree()
	if tree == null:
		Engine.time_scale = 1.0
		return

	# Timer parameters: time_sec, process_always=true, process_in_physics=false, ignore_time_scale=true
	var timer := tree.create_timer(duration, true, false, true)
	timer.timeout.connect(func():
		_hit_stop_active = false
		Engine.time_scale = 1.0
	)

# Safety helper to ensure time scale is fully restored (used on death, pauses, or scene changes)
func reset_time_scale() -> void:
	_hit_stop_active = false
	Engine.time_scale = 1.0

# Attaches smooth scale-up on hover and scale-down on mouse exit for interactive buttons.
func setup_button_hover(btn: Button, hover_scale: float = 1.06, duration: float = 0.12) -> void:
	if btn == null:
		return
	
	# Set pivot point to center so button scales symmetrically
	btn.pivot_offset = btn.size / 2.0
	btn.resized.connect(func():
		btn.pivot_offset = btn.size / 2.0
	)

	btn.mouse_entered.connect(func():
		var tween := btn.create_tween()
		tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		tween.tween_property(btn, "scale", Vector2(hover_scale, hover_scale), duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	)

	btn.mouse_exited.connect(func():
		var tween := btn.create_tween()
		tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		tween.tween_property(btn, "scale", Vector2.ONE, duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	)

# Fades in a UI element while sliding it downward into its intended position.
func slide_fade_in(node: Control, duration: float = 0.35, offset_y: float = -15.0) -> void:
	if node == null:
		return
	var final_pos := node.position
	node.position.y += offset_y
	node.modulate.a = 0.0

	var tween := node.create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.set_parallel(true)
	tween.tween_property(node, "position:y", final_pos.y, duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(node, "modulate:a", 1.0, duration)

# Pops in a UI element with a playful bounce effect (used on titles and win banners).
func bounce_in(node: Control, duration: float = 0.45) -> void:
	if node == null:
		return
	node.pivot_offset = node.size / 2.0
	node.scale = Vector2(0.4, 0.4)
	node.modulate.a = 0.0

	var tween := node.create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.set_parallel(true)
	tween.tween_property(node, "scale", Vector2.ONE, duration).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(node, "modulate:a", 1.0, duration * 0.5)
