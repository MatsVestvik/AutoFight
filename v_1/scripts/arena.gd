extends Node2D

@onready var team: Node2D = $Team
@onready var team_2: Node2D = $Team2

@export var peasant: unitData;
@export var archer: unitData;

var team_array: Array[unitData] = []
var team_array_2: Array[unitData] = []

func _ready() -> void:
	team_array = GameManager.get_team()
	team_array_2 = [archer, archer, archer, null, archer, peasant]
	
	team.import_team_data(team_array)
	team_2.import_team_data(team_array_2)
	
	team.unit_triggered_signal.connect(func(dmg): team_2.take_damage(dmg))
	team_2.unit_triggered_signal.connect(func(dmg): team.take_damage(dmg))
	team.death_signal.connect(on_lose_battle)
	team_2.death_signal.connect(on_win_battle)

func on_lose_battle() -> void:
	GameManager.player_team_data = team.export_team_data()
	GameManager.coins += 10
	get_tree().change_scene_to_file("res://scenes/delta_hearts.tscn")

func on_win_battle() -> void:
	GameManager.player_team_data = team.export_team_data()
	GameManager.coins += 10
	get_tree().change_scene_to_file("res://scenes/delta_trophys.tscn")
	
func _on_button_pressed() -> void:
	GameManager.player_team_data = team.export_team_data()
	GameManager.coins += 10
	get_tree().change_scene_to_file("res://scenes/shop.tscn")
