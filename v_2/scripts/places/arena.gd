extends Node2D

@onready var custom_button: Button = $CustomButton
@onready var arena_team: Team = $ArenaTeam

func _ready() -> void:
	arena_team.load_team(GameManager.team)
	
func _on_custom_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/places/shop.tscn")
