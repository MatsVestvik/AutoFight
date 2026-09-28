extends Node

var player_team_data: Array[unitData] = []

const PEASANT_DATA = preload("res://resource/peasant.tres")
const ARCHER_DATA = preload("res://resource/archer.tres")

@export var available_pool: Array[unitData] = []

func _ready() -> void:
	available_pool = [ARCHER_DATA, PEASANT_DATA]
	player_team_data.resize(6)
	#player_team_data.fill(null)

func save_team(grid: Array[unitData]) -> void:
	player_team_data = grid.duplicate()

func get_team() -> Array[unitData]:
	return player_team_data
		
