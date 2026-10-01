extends Control

@onready var label: Label = $Label
@onready var sprite_2d: Sprite2D = $Sprite2D

const FIRE = preload("uid://bm3rqv0ijuhrf")
const NORMAL = preload("uid://dwleuufsmenp2")
const POISON = preload("uid://y5vxvwqgjc3i")

func set_color(color: String) -> void:
	if not sprite_2d:
		return
	if color == "FIRE":
		sprite_2d.texture = FIRE
	if color == "POISON":
		sprite_2d.texture = POISON
	if color == "NORMAL":
		sprite_2d.texture = NORMAL
	return
	
func set_info(amount: int) -> void:
	if not label:
		return
	label.text = str(amount)
