extends Button
class_name superUnit

@onready var attack_label: Label = $attack
@onready var sprite_2d: Sprite2D = $Sprite2D

var current_timer: float = 0.0
var unit_data = unitData

signal trigger_signal (unit:Unit)

func _ready() -> void:
	return
	
func setup(data:unitData) -> void:
	unit_data = data.duplicate()
	sprite_2d.texture = data.sprite;
	attack_label.text = str(data.attack);


func trigger() -> void:
	trigger_signal.emit(self)
	print(unit_data.unit_name, " triggered")
	
