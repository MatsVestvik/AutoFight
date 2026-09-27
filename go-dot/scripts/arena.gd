extends Node2D

@onready var team: Node2D = $Team
@onready var team_2: Node2D = $Team2

@export var peasant: unitData;
@export var archer: unitData;

var team_array: Array[unitData] = []
var team_array_2: Array[unitData] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	team_array = [peasant, null, peasant, null, peasant, archer]
	team_array_2 = [archer, archer, archer, null, archer, peasant]
	
	team.import_team_data(team_array)
	team_2.import_team_data(team_array_2)
	
	team.unit_triggered_signal.connect(func(dmg): team_2.take_damage(dmg))
	team_2.unit_triggered_signal.connect(func(dmg): team.take_damage(dmg))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func summon_team() -> void:
	pass
	
func attack(damage: int) -> void:
	team.take_damage(damage)
	return
	
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/shop.tscn")
