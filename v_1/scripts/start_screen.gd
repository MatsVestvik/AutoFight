extends Node2D

@onready var button: Button = $Button
@onready var button_2: Button = $Button2
@onready var button_3: Button = $Button3



func _ready() -> void:
	button.pressed.connect(start_game)
	button_3.pressed.connect(quit_game)
	pass

func start_game() -> void:
	get_tree().change_scene_to_file("res://scenes/shop.tscn")
	
func quit_game() -> void:
	get_tree().quit()
