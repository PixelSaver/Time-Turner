extends Resource
class_name BaseUpgradeStrategy

@export var texture : Texture2D = preload("res://Assets/icon.svg")
@export var upgrade_text : String = "Speed"
@export var upgrade_description : String = ""
@export var price_in_seconds : float = 1.
## Whether or not the upgrade is applied when it's first added
@export var on_added := false

func apply_upgrade(timeturner:TimeTurner):
	pass
