extends Button
class_name UpgradeButton

signal upgrade_pressed(upgrade:BaseUpgradeStrategy)

@export var stored_upgrade : BaseUpgradeStrategy
@export var title_label : RichTextLabel
@export var desc_label : RichTextLabel
@export var texture_rect : TextureRect
@export var price_label : RichTextLabel
var time_turner : TimeTurner
var tween : Tween
var buyable : bool = false
var level : int = 0
var time_man : TimeManager
var scaled_price : float

func manual_init():
	grab_focus()
	pivot_offset = size/2
	time_turner = get_tree().get_first_node_in_group("TimeTurner")
	title_label.text = stored_upgrade.upgrade_text
	desc_label.text = stored_upgrade.upgrade_description
	texture_rect.texture = stored_upgrade.texture
	
	time_man = Global.time_manager
	time_man.connect("time_turned_signal", _update_buyable)
	_update_buyable(0.)
	
	update_price()

func update_price():
	var curr = stored_upgrade.price_in_seconds
	scaled_price = curr * exp(float(level)/3.)
	
	price_label.clear()
	price_label.append_text("[color=grey][font_size=12]Price: %s" % time_man.format_time_amount(scaled_price))

func _update_buyable(new_total:float):
	buyable = true if (new_total > scaled_price or is_equal_approx(new_total, scaled_price)) else false
	if buyable:
		modulate = Color.WHITE
	else:
		modulate = Color.FIREBRICK

func _on_pressed() -> void:
	if buyable:
		level += 1
		upgrade_pressed.emit(stored_upgrade)
		update_price()
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
