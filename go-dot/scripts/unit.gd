extends Node2D
class_name Unit

@onready var attack: Label = $attack
@onready var cooldown: Label = $cooldown
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	return
	
func flip() -> void:
	sprite_2d.flip_h = !sprite_2d.flip_h;
	
func setup(data:unitData) -> void:
	sprite_2d.texture = data.sprite;
	attack.text = str(data.attack);
	cooldown.text = str(data.cooldown_speed);
	
