extends Button
class_name UpgradeButton

signal upgrade_pressed(upgrade:BaseUpgradeStrategy)

@export var stored_upgrade : BaseUpgradeStrategy
@export var title_label : RichTextLabel
@export var desc_label : RichTextLabel
@export var texture_rect : TextureRect
var time_turner : TimeTurner
var tween : Tween
var buyable : bool = false

func manual_init():
	grab_focus()
	pivot_offset = size/2
	time_turner = get_tree().get_first_node_in_group("TimeTurner")
	title_label.text = stored_upgrade.upgrade_text
	desc_label.text = stored_upgrade.upgrade_description
	texture_rect.texture = stored_upgrade.texture
	
	var time_man = Global.time_manager
	time_man.connect("time_turned_signal", _update_buyable)
	_update_buyable(0.)

func _update_buyable(new_total:float):
	buyable = true if new_total > stored_upgrade.price_in_seconds else false
	if buyable:
		modulate = Color.WHITE
	else:
		modulate = Color.FIREBRICK

func _on_pressed() -> void:
	if buyable:
		upgrade_pressed.emit(stored_upgrade)
	if tween: tween.kill()
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "scale", Vector2.ONE * 1.1, 0.05)
	tween.tween_property(self, "scale", Vector2.ONE * 1.2, 0.25)

func _on_mouse_entered() -> void:
	if tween: tween.kill()
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "scale", Vector2.ONE * 1.2, 0.3)


func _on_mouse_exited() -> void:
	if tween: tween.kill()
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "scale", Vector2.ONE, 0.3)
