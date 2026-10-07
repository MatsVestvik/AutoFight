extends Button

const FREEZE_UP = preload("uid://bvd5x72oie3qf")
const FREEZE_DOWN = preload("uid://chpfymtvsuwmu")

@onready var frozen: PanelContainer = $Frozen
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var label: Label = $Label

var toggled_freeze: bool = false

func _on_pressed() -> void:
	toggled_freeze = !toggled_freeze
	if toggled_freeze:
		sprite_2d.texture = FREEZE_DOWN
		label.position = Vector2(0,8)
		frozen.show()
	else:
		sprite_2d.texture = FREEZE_UP
		label.position = Vector2(0,0)
		frozen.hide()
