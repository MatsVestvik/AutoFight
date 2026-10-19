extends Node2D

func _on_new_game_button_pressed() -> void:
	GameManager.reset_game()
	get_tree().change_scene_to_file("res://scenes/places/shop.tscn")

func _on_settings_button_pressed() -> void:
	pass

func _on_quit_button_pressed() -> void:
	get_tree().quit()
