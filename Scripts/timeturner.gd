extends Node3D

@export var inner_ring : PhysicsBody3D
@export var center : PhysicsBody3D

var rotation_speed : float = .3
var max_rotation_speed : float = 1

var inner_target_quat : Quaternion
var center_target_local_quat : Quaternion

var inner_t : Tween
var center_t : Tween
var flip_duration : float = .5

func _ready():
	inner_target_quat = inner_ring.transform.basis.get_rotation_quaternion()
	center_target_local_quat = Quaternion.IDENTITY
	Global.ring_pressed.connect(Callable(_on_ring_pressed))

func _on_ring_pressed(ring:int):
	match ring:
		Global.Rings.CENTER:
			start_center_flip()
		Global.Rings.INNER:
			start_inner_flip()
		Global.Rings.OUTER:
			pass

func _physics_process(delta: float) -> void:
	#if Input.is_action_just_pressed("ui_down"):
		#start_inner_flip()
	#if Input.is_action_just_pressed("ui_up"):
		#start_center_flip()
	
	if not center_t or not center_t.is_running():
		update_center_follow_inner()

func start_inner_flip() -> void:
	if inner_t:
		if inner_t.get_total_elapsed_time() < flip_duration:
			return
		inner_t.kill()
	
	var z_axis = Vector3.FORWARD
	var flip_rotation = Quaternion(z_axis, PI)
	inner_target_quat = inner_target_quat * flip_rotation 
	
	var start_quat = inner_ring.transform.basis.get_rotation_quaternion()
	
	inner_t = create_tween()
	inner_t.set_trans(Tween.TRANS_QUINT)
	#inner_t.set_ease(Tween.EASE_OUT)
	
	inner_t.tween_method(func(t):
		var current = start_quat.slerp(inner_target_quat, t)
		inner_ring.transform.basis = Basis(current)
		
		if not center_t or not center_t.is_running():
			update_center_follow_inner()
	, 0.0, 1.0, flip_duration)

func start_center_flip() -> void:
	if center_t:
		if center_t.get_total_elapsed_time() < flip_duration:
			return
		center_t.kill()
	
	var x_axis = Vector3.RIGHT
	var flip_rotation = Quaternion(x_axis, PI)
	center_target_local_quat = center_target_local_quat * flip_rotation
	
	# center's LOCAL rotation
	var inner_quat = inner_ring.transform.basis.get_rotation_quaternion()
	var center_quat = center.transform.basis.get_rotation_quaternion()
	var start_local_quat = inner_quat.inverse() * center_quat
	
	center_t = create_tween()
	center_t.set_trans(Tween.TRANS_QUINT)
	#center_t.set_ease(Tween.EASE_IN)
	
	center_t.tween_method(func(t):
		var current_inner_quat = inner_ring.transform.basis.get_rotation_quaternion()
		
		var current_local = start_local_quat.slerp(center_target_local_quat, t)
		
		# inner ring rotation + local rotation
		center.transform.basis = Basis(current_inner_quat * current_local)
	, 0.0, 1.0, flip_duration)

## Make center follow inner ring rotation with its local rotation
func update_center_follow_inner():
	var inner_quat = inner_ring.transform.basis.get_rotation_quaternion()
	center.transform.basis = Basis(inner_quat * center_target_local_quat)
