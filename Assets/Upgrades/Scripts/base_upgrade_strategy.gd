extends Resource
class_name BaseUpgradeStrategy

@export var texture : Texture2D = preload("res://Assets/icon.svg")
@export var upgrade_text : String = "Speed"
@export var upgrade_description : String = ""

func apply_upgrade(timeturner:Time)
