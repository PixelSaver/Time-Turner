extends Node3D

@export var inner_ring : PhysicsBody3D
@export var center : PhysicsBody3D
var rotation_speed : float = 10

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("ui_left"):
		var torque_strength = 10.0

		# Spin inner ring
		var torque_inner = inner_ring.global_transform.basis.z * torque_strength
		inner_ring.apply_torque(torque_inner)

		# Spin center: shared + local
		var torque_shared = torque_inner
		var torque_local = center.global_transform.basis.x * torque_strength
		center.apply_torque(torque_shared + torque_local)
	if Input.is_action_pressed("ui_right"):
		
		quat_rot(-rotation_speed * delta, -rotation_speed * delta / 3)

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
