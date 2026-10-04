extends Node2D
class_name InfoView

@onready var sprite: Sprite2D = $Sprite
@onready var close_button: Button = $Close_Button
@onready var cooldown_label: Label = $Cooldown_Label
@onready var cooldown: Label = $Cooldown
@onready var name_label: Label = $Name_Label
@onready var description: Label = $Description
@onready var stats_container: Node2D = $StatsContainer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func connect_disk(unit:shop_unit)-> void:
	unit.info.connect(set_info)
	
func set_info(unit: shop_unit) -> void:
	name_label.text = unit.unit_data.unit_name
	sprite.texture = unit.unit_data.sprite
	cooldown.text = str(unit.unit_data.cooldown_speed)
	description.text = unit.unit_data.description
	stats_container.create_from_unit_data(unit.unit_data)
	
func _process(delta: float) -> void:
	pass


func _on_close_button_pressed() -> void:
	hide()
