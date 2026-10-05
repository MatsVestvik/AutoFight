extends Node2D

@onready var custom_button: Button = $CustomButton

func _ready() -> void:
	GameManager.team

func _on_custom_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/places/shop.tscn")
