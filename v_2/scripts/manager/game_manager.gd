extends Node

var units: Array[UnitData] = []
var team: Array[UnitData] = []

signal unit_hovered(unit_data: UnitData)
signal unit_unhovered()

func _ready() -> void:
	units = get_all_unit_data()
	
func get_all_unit_data() -> Array[UnitData]:
	var unit_data_list: Array[UnitData] = []
	var dir_path := "res://resources/"
	
	for file in DirAccess.get_files_at(dir_path):
		# When exporting, Godot sometimes adds '.remap' to .tres files
		var clean_file := file.trim_suffix(".remap")
		
		if clean_file.ends_with(".tres") or clean_file.ends_with(".res"):
			var resource = load(dir_path.path_join(clean_file))
			if resource is UnitData and not unit_data_list.has(resource):
				unit_data_list.append(resource)

	return unit_data_list
