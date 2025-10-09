extends Node3D

@export var inner_ring : PhysicsBody3D
var inner_vel : float
var inner_flips : int = 0
@export var center : PhysicsBody3D
var center_vel : float
var center_flips : int = 0
var rotation_speed : float = .3
var max_rotation_speed : float = 1

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_down"):
		inner_flips += 1
		update_flip(delta)
	if Input.is_action_just_pressed("ui_up"):
		center_flips += 1
		update_flip(delta)
	
	
	#if Input.is_action_pressed("ui_left"):
		#inner_vel += -rotation_speed * delta
		#center_vel += -rotation_speed * delta
		#
	#elif Input.is_action_pressed("ui_right"):
		#inner_vel += rotation_speed * delta
		#center_vel += rotation_speed * delta
	#else:
		#inner_vel = move_toward(inner_vel, 0, delta /5)
		#center_vel = move_toward(center_vel, 0, delta /5)
	
	#inner_vel = clampf(inner_vel,  -max_rotation_speed, max_rotation_speed)
	#center_vel = clampf(center_vel,  -max_rotation_speed, max_rotation_speed)
	#quat_rot(center_vel, inner_vel/3)

var inner_t : Tween
var center_t : Tween
var flip_duration : float = 10
func update_flip(delta: float) -> void:
	if inner_flips > 0:
		if inner_t:
			inner_t.kill()

		var start_inner := inner_ring.transform.basis.get_rotation_quaternion()
		var target_inner := Quaternion(inner_ring.transform.basis.z.normalized(), PI * inner_flips) * start_inner

		inner_t = create_tween()
		inner_t.set_trans(Tween.TRANS_ELASTIC)
		inner_t.set_ease(Tween.EASE_OUT)

		inner_t.tween_method(func(t):
			var q_interp := start_inner.slerp(target_inner, t)
			# Apply shared rotation to inner ring
			inner_ring.transform.basis = Basis(q_interp)
			# Let quat_rot handle hierarchical rotation for center
			quat_rot(0, inner_flips * t)
		, 0.0, 1.0, flip_duration)


	# Center flip
	#if center_flips > 0:
		#if center_t:
			#center_t.kill()
#
		#var q_start_center := center.transform.basis.get_rotation_quaternion()
		#var local_axis := inner_ring.transform.basis.z.normalized()
		#var q_target_center := Quaternion(Vector3.RIGHT, PI * center_flips) * q_start_center
#
		#center_t = create_tween()
		#center_t.set_trans(Tween.TRANS_ELASTIC)
		#center_t.set_ease(Tween.EASE_OUT)
#
		#center_t.tween_method(func(t):
			#var q_interp := q_start_center.slerp(q_target_center, t)
			#center.transform.basis = Basis(q_interp)
		#, 0.0, 1.0, flip_duration)

		#center_t.tween_callback(Callable(self, "_on_center_flip_done"))

func flip_ring(tween:Tween, bodies:Array[PhysicsBody3D], axis:Vector3, flip_num:int=1):
	if tween:
		tween.kill()

	var q_start := bodies[0].transform.basis.get_rotation_quaternion()

	var q_target := Quaternion(axis, PI * inner_flips) * q_start

	tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)

	# Animate using slerp interpolation
	tween.tween_method(func(t):
		var q_interp := q_start.slerp(q_target, t)
		for body in bodies:
			body.transform.basis = Basis(q_interp)
	, 0.0, 1.0, flip_duration)

## Written with the help of ChatGPT
func quat_rot(angle_center:float, angle_inner:float, angle_outer=null):
	if angle_outer: return
	
	# Shared rotation (around inner_ring's Z, in parent space)
	var shared_axis = inner_ring.transform.basis.z.normalized()
	var q_shared = Quaternion(shared_axis, angle_inner)

	# Local spin around center's own X axis
	var q_local = Quaternion(Vector3.RIGHT, angle_center)

	inner_ring.transform.basis = Basis(q_shared) * inner_ring.transform.basis
	center.transform.basis = Basis(q_shared) * center.transform.basis * Basis(q_local)
