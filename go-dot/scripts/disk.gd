extends Node2D
class_name Disk

@onready var slots: Array[Marker2D] = [$Slot_1, $Slot_2, $Slot_3, $Slot_4, $Slot_5]

@export var unit_scene: PackedScene;
@export var shop_unit_scene: PackedScene;
@export var peasant: unitData;
@export var archer: unitData;

var row: Array[shop_unit] = []

func _ready() -> void:
	row.resize(5);
	row.fill(null);
	spawn_unit(peasant, 0)
	spawn_unit(archer, 1)
	spawn_unit(peasant, 2)
	spawn_unit(archer, 3)
	spawn_unit(archer, 4)

func get_slot_position(index: int) -> Vector2:
	return slots[index].position
	
func place_unit(unit:shop_unit, index: int) -> bool:
	if row[index] != null:
		print ("Slot occupied")
		return false
		
	row[index] = unit
	
	unit.position = get_slot_position(index)
	
	return true
	
signal buy(data:unitData)

func connect_unit(unit:shop_unit)->void:
	unit.buy.connect(on_unit_buy)
	unit.drag_ended.connect(_on_unit_drag_ended)

func _on_unit_drag_ended(unit: shop_unit) -> void:
	unit.reset_position()
	
func on_unit_buy(data:unitData) -> void:
	print("registered in disk")
	buy.emit(data)
	
func spawn_unit(data: unitData, index: int) -> void:
	
	var new_unit: shop_unit = shop_unit_scene.instantiate()
	
	add_child(new_unit)
	connect_unit(new_unit)
	place_unit(new_unit, index);
	new_unit.setup(data)
