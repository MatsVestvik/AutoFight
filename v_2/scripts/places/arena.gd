extends Node2D

@onready var custom_button: Button = $CustomButton
@onready var team_1: Node2D = $Team_1
@onready var team_2: Node2D = $Team_2

func _ready() -> void:
	team_1.arena_team.load_team(GameManager.team)
	
func _on_custom_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/places/shop.tscn")
