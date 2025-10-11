extends Button
class_name UpgradeButton

signal upgrade_pressed(upgrade:BaseUpgradeStrategy)

@export var stored_upgrade : BaseUpgradeStrategy
@export var title_label : RichTextLabel
@export var desc_label : RichTextLabel
@export var texture_rect : TextureRect
var time_turner : TimeTurner

func manual_init():
	time_turner = get_tree().get_first_node_in_group("TimeTurner")
	title_label.text = stored_upgrade.upgrade_text
	desc_label.text = stored_upgrade.upgrade_description
	texture_rect.texture = stored_upgrade.texture

func _on_pressed() -> void:
	upgrade_pressed.emit(stored_upgrade)

func _on_mouse_entered() -> void:
	print_debug("hey mouse entered")


func _on_mouse_exited() -> void:
	pass # Replace with function body.
