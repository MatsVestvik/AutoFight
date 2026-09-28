extends Node2D

const MAX_MEMBERS = 6

var team_array: Array[unitData] = []

@export var team_scene: PackedScene
@export var peasant: unitData;
@export var archer: unitData;
@onready var disk: Disk = $Disk

@onready var team_slot: Marker2D = $Team_Slot

var active_team: Team

var grid: Array[Unit] = []

func _ready() -> void:
	team_array = GameManager.get_team()
	setup_team(team_array)
	connect_disk(disk)
	pass # Replace with function body.

func setup_team(unit_data: Array[unitData])->void:
	active_team = team_scene.instantiate()
	add_child(active_team)
	
	active_team.import_team_data(unit_data)
	
	active_team.position = team_slot.position
	return

func _on_battle_pressed() -> void:
	var team_to_save: Array[unitData] = active_team.export_team_data()
	
	GameManager.save_team(team_to_save)
	
	get_tree().change_scene_to_file("res://scenes/arena.tscn")

func connect_disk(disk:Disk)->void:
	disk.buy.connect(buy_unit)
	
func buy_unit(data:unitData) -> bool:
	if not active_team:
		return false
	
	var current_team: Array[unitData] = active_team.export_team_data()
	var free_slot_index: int = current_team.find(null)
	
	if free_slot_index == -1:
		print("team full")
		return false
	current_team[free_slot_index] = data
	active_team.import_team_data(current_team)
	
	print("Bought unit")
	return true
