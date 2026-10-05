extends Node2D

func _on_custom_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/places/arena.tscn")
