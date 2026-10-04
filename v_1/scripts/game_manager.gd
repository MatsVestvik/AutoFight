extends Node

var player_team_data: Array[unitData] = []
var coins: int = 100
var hearts: int = 10
var trophys: int = 0

const PEASANT_DATA = preload("res://resource/peasant.tres")
const ARCHER_DATA = preload("res://resource/archer.tres")
const WIZARD_DATA = preload("res://resource/wizard.tres")
const GOBLIN_DATA = preload("uid://cps58isp7mblo")

@export var available_pool: Array[unitData] = []

func _ready() -> void:
	available_pool = [ARCHER_DATA, PEASANT_DATA, WIZARD_DATA, GOBLIN_DATA]
	player_team_data.resize(6)

func save_team(grid: Array[unitData]) -> void:
	player_team_data = grid.duplicate()

func get_team() -> Array[unitData]:
	return player_team_data
		
