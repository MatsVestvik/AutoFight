extends shop_unit
class_name disk_unit

@onready var cooldown_label: Label = $cooldown_label
@onready var coins_label: Label = $Coins_Label
@onready var border: Sprite2D = $Border
const SELECTED = preload("uid://c2p0d3kafiuv5")
const NORMAL = preload("uid://b7fmg8vkqyli1")

func setup(data:unitData) -> void:
	unit_data = data.duplicate()
	sprite_2d.texture = data.sprite;
	attack_label.text = str(data.attack);
	cooldown_label.text = str(data.cooldown_speed)
	coins_label.text = str(data.cost)

func _on_mouse_entered() -> void:
	border.texture = SELECTED


func _on_mouse_exited() -> void:
	border.texture = NORMAL
