extends PanelContainer

func _on_quit_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/places/start_screen.tscn")
