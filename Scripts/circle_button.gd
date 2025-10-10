extends Button
class_name CircleButton

signal ring_pressed(ring)


const BUTTON_DISTANCES = [
	320,
	270,
	220,
]

func _ready() -> void:
	Global.circle_button = self

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		pass

func _process(delta: float) -> void:
	var mouse_dist = get_global_mouse_position().distance_to(global_position + size/2)
	if mouse_dist < 220:
		Global.hovered_ring = Global.Rings.CENTER
	elif mouse_dist < 270:
		Global.hovered_ring = Global.Rings.INNER
	elif mouse_dist < 220:
		Global.hovered_ring = Global.Rings.OUTER
	else:
		Global.hovered_ring = Global.Rings.NONE
