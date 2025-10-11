extends Node3D
class_name TimeTurner

@export var inner_ring : PhysicsBody3D
@export var center : PhysicsBody3D

var rotation_speed : float = .3
var max_rotation_speed : float = 1

var inner_target_quat : Quaternion
var center_target_local_quat : Quaternion

var inner_t : Tween
var center_t : Tween
var flip_duration : float = .5

# Mults for upgrades
var initial_prices = [
	1.,
	300.,
]
var center_mults: Dictionary  = {
	last_spin = 0.,
	auto = 100,
	unlocked = 0,
	mult = 1.,
	duration = .5,
}
var inner_mults : Dictionary = {
	last_spin = 0.,
	auto = 0,
	unlocked = 0,
	mult = 1.,
	duration = 5.5,
}
var outer_mults : Dictionary = {
	last_spin = 0.,
	auto = 0,
	unlocked = 0,
	mult = 1.,
	duration = .5,
}

func _ready():
	inner_target_quat = inner_ring.transform.basis.get_rotation_quaternion()
	center_target_local_quat = Quaternion.IDENTITY
	Global.ring_pressed.connect(Callable(_on_ring_pressed))
	Global.timeturner = self

func add_upgrade(upgrade:BaseUpgradeStrategy):
	if not upgrade: return
	upgrade.apply_upgrade(self)


func _on_ring_pressed(ring:int):
	match ring:
		Global.Rings.CENTER:
			start_center_flip()
				
		Global.Rings.INNER:
			if inner_mults.unlocked > 0:
				start_inner_flip()
		Global.Rings.OUTER:
			pass

func _process(delta: float) -> void:
	if center_mults.auto > 0:
		if Time.get_unix_time_from_system() - center_mults.last_spin > center_mults.duration * 3 / log(center_mults.auto+1):
			call_deferred("_turn_center_time_safe")
	if inner_mults.auto > 0:
		if Time.get_unix_time_from_system() - inner_mults.last_spin > inner_mults.duration * 3 / log(inner_mults.auto+1):
			var turned = 1 * pow(inner_mults.mult,2)
			Global.time_manager.turn_time(turned)
			inner_mults.last_spin = Time.get_unix_time_from_system()
			call_deferred("_turn_inner_time_safe")
func _turn_center_time_safe():
	var turned = 1 * pow(center_mults.mult,2)
	Global.time_manager.turn_time(turned)
	center_mults.last_spin = Time.get_unix_time_from_system()
func _turn_inner_time_safe():
	var turned = 1 * pow(inner_mults.mult,2)
	Global.time_manager.turn_time(turned)
	inner_mults.last_spin = Time.get_unix_time_from_system()
func _physics_process(delta: float) -> void:
	if not center_t or not center_t.is_running():
		update_center_follow_inner()

func start_inner_flip() -> bool:
	if inner_t:
		if inner_t.get_total_elapsed_time() < inner_mults.duration:
			return false
		inner_t.kill()
	
	var z_axis = Vector3.FORWARD
	var flip_rotation = Quaternion(z_axis, PI)
	inner_target_quat = inner_target_quat * flip_rotation 
	
	var start_quat = inner_ring.transform.basis.get_rotation_quaternion()
	
	inner_t = create_tween()
	inner_t.set_trans(Tween.TRANS_CUBIC)
	inner_t.set_ease(Tween.EASE_OUT)
	
	inner_t.tween_method(func(t):
		var current = start_quat.slerp(inner_target_quat, t)
		inner_ring.transform.basis = Basis(current)
		
		if not center_t or not center_t.is_running():
			update_center_follow_inner()
	, 0.0, 1.0, inner_mults.duration)
	
	await inner_t.finished
	# Add time reward after flipped
	var turned = 10 * inner_mults.mult
	Global.time_manager.turn_time(turned)
	return true

func start_center_flip() -> bool:
	if center_t:
		if center_t.get_total_elapsed_time() < center_mults.duration:
			return false
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
	, 0.0, 1.0, center_mults.duration)
	
	await center_t.finished
	# Add time reward after flipped
	var turned = 1 * pow(center_mults.mult,2)
	Global.time_manager.turn_time(turned)
	
	return true

## Make center follow inner ring rotation with its local rotation
func update_center_follow_inner():
	var inner_quat = inner_ring.transform.basis.get_rotation_quaternion()
	center.transform.basis = Basis(inner_quat * center_target_local_quat)
