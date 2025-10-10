extends Node

signal circle_button_ready
var circle_button : CircleButton : 
	set(val):
		circle_button = val
		circle_button_ready.emit()
signal hover_change(new_ring)
var hovered_ring = Rings.NONE :
	set(val):
		if hovered_ring == val: return
		hovered_ring = val
		hover_change.emit(val)
		
signal ring_pressed(ring)
enum Rings {
	NONE,
	CENTER,
	INNER,
	OUTER,
}

var time_manager : TimeManager
