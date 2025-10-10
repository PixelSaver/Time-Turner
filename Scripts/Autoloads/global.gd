extends Node

signal circle_button_ready
var circle_button : CircleButton : 
	set(val):
		circle_button = val
		circle_button_ready.emit()
var hovered_ring = Rings.NONE
signal ring_pressed(ring)
enum Rings {
	NONE,
	CENTER,
	INNER,
	OUTER,
}
