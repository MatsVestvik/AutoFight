extends PanelContainer
class_name InfoView

@onready var margin_container: MarginContainer = $MarginContainer
@onready var v_box_container: VBoxContainer = $MarginContainer/VBoxContainer
@onready var name_label: Label = $MarginContainer/VBoxContainer/Name_Label
@onready var sprite: Sprite2D = $MarginContainer/VBoxContainer/Sprite
@onready var category_h_box: HBoxContainer = $MarginContainer/VBoxContainer/Category_HBox
@onready var attack_name_label: Label = $MarginContainer/VBoxContainer/Category_HBox/Attack_Label
@onready var cooldown_name_label: Label = $MarginContainer/VBoxContainer/Category_HBox/Cooldown_Label
@onready var stats_h_box: HBoxContainer = $MarginContainer/VBoxContainer/Stats_HBox
@onready var attack_label: Label = $MarginContainer/VBoxContainer/Stats_HBox/Attack_Label
@onready var cooldown_label: Label = $MarginContainer/VBoxContainer/Stats_HBox/Cooldown_Label
@onready var description_label: Label = $MarginContainer/VBoxContainer/Description_Label
@onready var close_button: Button = $MarginContainer/VBoxContainer/Close_Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func connect_disk(unit:shop_unit)-> void:
	unit.info.connect(set_info)
	
func set_info(unit: shop_unit) -> void:
	name_label.text = unit.unit_data.unit_name
	sprite.texture = unit.unit_data.sprite
	attack_label.text = str(unit.unit_data.attack)
	cooldown_label.text = str(unit.unit_data.cooldown_speed)
	description_label.text = unit.unit_data.description
	
func _process(delta: float) -> void:
	pass


func _on_close_button_pressed() -> void:
	hide()
