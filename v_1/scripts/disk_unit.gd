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
	cooldown_label.text = str(data.cooldown_speed)
	coins_label.text = str(data.cost)
	stats_container.create_from_unit_data(data)
	
func _on_mouse_entered() -> void:
	selected.show()
	border.texture = SELECTED
	hover.emit(self)

func _on_mouse_exited() -> void:
	selected.hide()
	border.texture = NORMAL

func _on_button_down() -> void:
	original_pos = position
	buy.emit(self)
	pass
	
func _on_button_up() -> void:
	pass
