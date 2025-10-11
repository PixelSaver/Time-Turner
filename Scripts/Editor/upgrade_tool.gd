@tool
extends EditorScript

var directory = "res://Assets/Upgrades/"

func _run():
	print("=== UPGRADE FILES IN %s ===" % directory)
	var dir = DirAccess.open(directory)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		var count = 0
		
		while file_name != "":
			if file_name.ends_with(".tres"):
				print('preload("'+ directory + "/" + file_name + '"),' )
				count += 1
			file_name = dir.get_next()
			
		print("=== FOUND ", count, " UPGRADE FILES ===")
		print("Copy the preload lines above into your UpgradeManager all_upgrades array")
	else:
		print("Could not open res://Upgrades/Resources/ directory")
