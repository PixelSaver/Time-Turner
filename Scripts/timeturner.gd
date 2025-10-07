extends Node3D

@export var inner_ring : PhysicsBody3D
var inner_vel : float
@export var center : PhysicsBody3D
var center_vel : float
var rotation_speed : float = 10

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("ui_left"):
		inner_vel = -rotation_speed * delta
		center_vel = -rotation_speed * delta
	elif Input.is_action_pressed("ui_right"):
		inner_vel = rotation_speed * delta
		center_vel = rotation_speed * delta
	else:
		inner_vel = move_toward(inner_vel, 0, delta/10)
		center_vel = move_toward(center_vel, 0, delta/10)
	quat_rot(center_vel, inner_vel/3)

## Written with the help of ChatGPT
func quat_rot(angle_center, angle_inner, angle_outer=null):
	if angle_outer: return
	
	# Shared rotation (around inner_ring's Z, in parent space)
	var shared_axis := inner_ring.transform.basis.z.normalized()
	var q_shared := Quaternion(shared_axis, angle_inner)

	# Local spin around center's own X axis
	var q_local := Quaternion(Vector3.RIGHT, angle_center)

	# Apply
	inner_ring.transform.basis = Basis(q_shared) * inner_ring.transform.basis
	center.transform.basis = Basis(q_shared) * center.transform.basis * Basis(q_local)
