extends Button

@onready var button_sprite: Sprite2D = $ButtonSprite
@onready var selected: AnimatedSprite2D = $Selected
@onready var label: Label = $Label

@export var button_color: String = ""
@export var button_text: String = ""
@export var main_scale: Vector2

const BLUE = preload("uid://bqex2xhvss052")
const GREEN = preload("uid://vrsnbver6aya")
const RED = preload("uid://dl0ggtgj8qfel")

func _ready() -> void:
	set_color(button_color)
	set_label(button_text)
	set_scale(main_scale)
	selected.hide()

func set_color(color: String) -> void:
	if color == "RED":
		button_sprite.texture = RED
	elif color == "BLUE":
		button_sprite.texture = BLUE
	elif color == "GREEN":
		button_sprite.texture = GREEN
	else:
		return

func set_label(active_button_text: String) -> void:
	label.text = active_button_text

func _on_mouse_entered() -> void:
	selected.show()

func _on_mouse_exited() -> void:
	selected.hide()
