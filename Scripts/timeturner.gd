extends Node3D

@export var inner_ring : PhysicsBody3D
@export var center : PhysicsBody3D
var rotation_speed : float = 10

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("ui_left"):
		# Rotate inner_ring around its local Z axis
		var z_rotation = Quaternion(Vector3.FORWARD, rotation_speed * delta)
		inner_ring.transform.basis = Basis(z_rotation * Quaternion(inner_ring.transform.basis))
		
		# Apply same Z rotation to center in global space
		center.global_transform.basis = Basis(z_rotation * Quaternion(center.global_transform.basis))
		
		# Then rotate center around its own local X axis
		var x_rotation = Quaternion(Vector3.RIGHT, rotation_speed * delta)
		center.transform.basis = Basis(x_rotation * Quaternion(center.transform.basis))
		
	if Input.is_action_pressed("ui_right"):
		# Rotate inner_ring around its local Z axis (negative)
		var z_rotation = Quaternion(Vector3.FORWARD, -rotation_speed * delta)
		inner_ring.transform.basis = Basis(z_rotation * Quaternion(inner_ring.transform.basis))
		
		# Apply same Z rotation to center in global space
		center.global_transform.basis = Basis(z_rotation * Quaternion(center.global_transform.basis))
		
		# Then rotate center around its own local X axis (negative)
		var x_rotation = Quaternion(Vector3.RIGHT, -rotation_speed * delta)
		center.transform.basis = Basis(x_rotation * Quaternion(center.transform.basis))
