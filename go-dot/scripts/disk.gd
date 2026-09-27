extends Node2D

@onready var slot_1: Marker2D = $Slot_1
@onready var slot_2: Marker2D = $Slot_2
@onready var slot_3: Marker2D = $Slot_3
@onready var slot_4: Marker2D = $Slot_4
@onready var slot_5: Marker2D = $Slot_5

@export var unit_scene: PackedScene;
@export var peasant: unitData;
@export var archer: unitData;

var row: Array[Unit] = []

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
	
func place_unit(unit:Unit, index: int) -> bool:
	if row[index] != null:
		print ("Slot occupied")
		return false
		
	row[index] = unit
	
	unit.position = get_slot_position(index)
	
	return true
	
func spawn_unit(data: unitData, index: int) -> void:
	
	var new_unit: Unit = unit_scene.instantiate()
	
	add_child(new_unit)
	place_unit(new_unit, index);
	new_unit.setup(data)
