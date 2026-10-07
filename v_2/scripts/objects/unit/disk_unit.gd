extends Unit
class_name DiskUnit

@onready var cash: Sprite2D = $Cash
@onready var label: Label = $Cash/Label

signal buy(data:UnitData, disk_unit:DiskUnit)

func _ready() -> void:
	super._ready()
	_update_cost()

func create_from_data(input_data: UnitData) -> void:
	data = input_data
	get_node("Sprite2D").texture = data.texture
	if is_node_ready():
		_update_cost()
		_update_stats()

func _update_cost() -> void:
	if data and label:
		label.text = str(data.cost)
		
func _on_pressed() -> void:
	buy.emit(data, self)
