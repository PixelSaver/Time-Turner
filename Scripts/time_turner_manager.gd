extends Node3D

@export var center_arr : Array[GeometryInstance3D]
@export var inner_ring_arr : Array[GeometryInstance3D]
@export var outer_ring_arr : Array[GeometryInstance3D]
const MATERIAL = preload("res://Assets/gold_timeturner.tres")
const HIGHLIGHT_COL = Color(1.0, 0.922, 0.541)
const NORMAL_COL = Color(1.0, 0.8, 0.0)

func _ready() -> void:
	Global.hover_change.connect(_on_hover_changed)

func _on_hover_changed(newly_hovered: int) -> void:
	print("hover chagned to: %s" % newly_hovered)
	var groups = {
		Global.Rings.CENTER: center_arr,
		Global.Rings.INNER: inner_ring_arr,
		Global.Rings.OUTER: outer_ring_arr
	}
	for arr in [center_arr, inner_ring_arr, outer_ring_arr]:
		for thing in arr:
			thing.material_overlay = null
	if newly_hovered in groups:
		for thing in groups[newly_hovered]:
			var mat = thing.material_override.duplicate()
			mat.set_shader_parameter("ColorUniform", HIGHLIGHT_COL)
			thing.material_overlay = mat
			
