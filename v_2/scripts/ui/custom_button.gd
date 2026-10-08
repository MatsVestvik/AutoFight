extends Button

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var label: Label = $Label
@onready var selected: AnimatedSprite2D = $Selected
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const GREEN_1X_1 = preload("uid://buyskdebcsedc")
const YELLOW_1X_1 = preload("uid://uokr206a6yig")

@export var label_name: String = ""
@export var image: Texture2D

func _ready() -> void:
	label.text = label_name
	sprite_2d.texture = image
	selected.hide()

func _on_mouse_entered() -> void:
	SoundManager.play_sfx(SoundManager.MOUSE_ENTERED)
	selected.show()

func _on_mouse_exited() -> void:
	selected.hide()


func _on_pressed() -> void:
	SoundManager.play_sfx(SoundManager.CLICK)
