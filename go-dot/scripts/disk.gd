extends Node2D
class_name Disk

@onready var slot_1: Marker2D = $Slot_1
@onready var slot_2: Marker2D = $Slot_2
@onready var slot_3: Marker2D = $Slot_3
@onready var slot_4: Marker2D = $Slot_4
@onready var slot_5: Marker2D = $Slot_5

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
	pass

func get_slot_position(index: int) -> Vector2:
	var marker = get_child(index) as Marker2D
	return marker.position
	
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
	
func on_unit_buy(data:unitData) -> void:
	print("registered in disk")
	buy.emit(data)
	
func spawn_unit(data: unitData, index: int) -> void:
	
	var new_unit: shop_unit = shop_unit_scene.instantiate()
	
	add_child(new_unit)
	connect_unit(new_unit)
	place_unit(new_unit, index);
	new_unit.setup(data)
