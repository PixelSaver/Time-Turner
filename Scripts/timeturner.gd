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
		#quat_rot(0, rotation_speed * 100)
	
	
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

		inner_t = create_tween()
		inner_t.set_trans(Tween.TRANS_ELASTIC)
		inner_t.set_ease(Tween.EASE_OUT)

		var start_inner := inner_ring.transform.basis.get_rotation_quaternion()
		var start_center := center.transform.basis.get_rotation_quaternion()

		inner_t.tween_method(func(t):
			quat_rot(0, PI * inner_flips * t, start_inner, start_center)
		, 0.0, 1.0, flip_duration)
	
	# Center flip
	if center_flips > 0:
		if center_t:
			center_t.kill()

		center_t = create_tween()
		center_t.set_trans(Tween.TRANS_ELASTIC)
		center_t.set_ease(Tween.EASE_OUT)

		var start_inner := inner_ring.transform.basis.get_rotation_quaternion()
		var start_center := center.transform.basis.get_rotation_quaternion()

		center_t.tween_method(func(t):
			quat_rot(PI * center_flips * t, 0, start_inner, start_center)
		, 0.0, 1.0, flip_duration)


## Written with the help of ChatGPT
func quat_rot(angle_center:float, angle_inner:float, start_inner: Quaternion, start_center: Quaternion):
	
	var shared_axis = inner_ring.transform.basis.z.normalized()
	var q_shared = Quaternion(shared_axis, angle_inner)
	var q_local = Quaternion(Vector3.RIGHT, angle_center)

	# Apply rotation relative to start transforms
	inner_ring.transform.basis = Basis(q_shared * start_inner)
	center.transform.basis = Basis(q_shared * start_center * q_local)
