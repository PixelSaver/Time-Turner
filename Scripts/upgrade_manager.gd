extends Panel
class_name UpgradeManager

@onready var upgrade_scene : PackedScene = preload("res://Scenes/upgrade_button.tscn")
@onready var all_upgrades : Array = [
	preload("res://Assets/Upgrades//center_cooldown.tres"),
	preload("res://Assets/Upgrades//center_mult.tres"),
	preload("res://Assets/Upgrades//center_auto.tres"),
	
	preload("res://Assets/Upgrades/inner_unlock.tres"),
	preload("res://Assets/Upgrades//inner_cooldown.tres"),
	preload("res://Assets/Upgrades//inner_mult.tres"),
	preload("res://Assets/Upgrades/inner_auto.tres"),
	#preload("res://Assets/Upgrades//outer_cooldown.tres"),
	#preload("res://Assets/Upgrades//outer_mult.tres"),
]
@export var parent : Control

func _ready() -> void:
	for child in parent.get_children():
		child.queue_free()
	for i in range(4):
		instantiate_update(all_upgrades[i])
			

func instantiate_update(upgrade:BaseUpgradeStrategy):
	var inst = upgrade_scene.instantiate() as UpgradeButton
	parent.add_child(inst)
	inst.stored_upgrade = upgrade
	inst.connect("upgrade_pressed", apply_upgrade)
	inst.manual_init()

func apply_upgrade(upgrade:BaseUpgradeStrategy):
	var timeturner = get_tree().get_first_node_in_group("TimeTurner") as TimeTurner
	Global.time_manager.time_turned -= upgrade.price_in_seconds
	timeturner.add_upgrade(upgrade)
	match upgrade.unlock_index:
		1:
			instantiate_update(all_upgrades[4])
			instantiate_update(all_upgrades[5])
			instantiate_update(all_upgrades[6])
