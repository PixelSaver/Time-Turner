extends MeshInstance3D

func _process(delta):
	var mp = get_viewport().get_mouse_position()
	var size = get_viewport().get_visible_rect().size
	material_override.set_shader_parameter("uv_scale", mesh.size)
	material_override.set_shader_parameter("mouse_pos", mp / size)
