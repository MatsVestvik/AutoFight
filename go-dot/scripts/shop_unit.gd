extends Button

class_name shop_unit

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var attack: Label = $attack

var data: unitData

signal buy(data:unitData)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func setup(unit: unitData) -> void:
	self.data = unit
	sprite_2d.texture = unit.sprite
	attack.text = str(unit.attack)
	return

func _on_pressed() -> void:
	print("buying")
	buy.emit(data)
