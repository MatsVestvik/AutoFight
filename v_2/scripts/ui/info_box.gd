extends PanelContainer
class_name InfoBox

@onready var name_label: Label = $MarginContainer/VBoxContainer/Name
@onready var sprite_2d: Sprite2D = $MarginContainer/VBoxContainer/Sprite2D

func _ready() -> void:
	hide()
	GameManager.unit_hovered.connect(display_unit)
	GameManager.unit_unhovered.connect(clear)

func display_unit(unit_data: UnitData) -> void:
	if unit_data == null:
		clear()
		return
	
	name_label.text = unit_data.name
	if unit_data.texture:
		sprite_2d.texture = unit_data.texture
	show()

func clear() -> void:
	hide()
