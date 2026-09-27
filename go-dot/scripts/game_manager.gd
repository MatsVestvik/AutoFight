extends Node

var player_team_data: Array[unitData] = []

func _ready() -> void:
	player_team_data.resize(6)
	#player_team_data.fill(null)

func save_team(grid: Array[unitData]) -> void:
	player_team_data = grid.duplicate()

func get_team() -> Array[unitData]:
	return player_team_data
