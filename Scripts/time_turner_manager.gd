extends Node3D

@export var center_arr : Array[GeometryInstance3D]
@export var inner_ring_arr : Array[GeometryInstance3D]
@export var outer_ring_arr : Array[GeometryInstance3D]
const MATERIAL = preload("res://Assets/gold_timeturner.tres")
const HIGHLIGHT_COL = Color(1.0, 0.922, 0.541)
const NORMAL_COL = Color(1.0, 0.8, 0.0)

func _process(_delta: float) -> void:
	var groups = {
		Global.Rings.CENTER: [center_arr],
		Global.Rings.INNER: [inner_ring_arr],
		Global.Rings.OUTER: [outer_ring_arr]
	}
	for arr in [center_arr, inner_ring_arr, outer_ring_arr]:
		for thing in arr:
			thing.material_overlay = null
	if Global.hovered_ring in groups:
		for arr in groups[Global.hovered_ring]:
			for thing in arr:
				var mat = thing.material_override.duplicate()
				mat.set_shader_parameter("ColorUniform", HIGHLIGHT_COL)
				thing.material_overlay = mat
			
