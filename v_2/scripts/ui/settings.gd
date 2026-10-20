extends PanelContainer

const CLOSE = preload("res://assets/icons/close.png")
const HOVER_CLOSE = preload("res://assets/icons/hover_close.png")

@onready var close_button: Button = $Window/CloseButton

func _on_quit_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/places/start_screen.tscn")


func _on_close_button_pressed() -> void:
	hide()


func _on_close_button_mouse_entered() -> void:
	close_button.icon = HOVER_CLOSE


func _on_close_button_mouse_exited() -> void:
	close_button.icon = CLOSE
