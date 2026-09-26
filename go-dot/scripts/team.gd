extends Node2D

const MAX_MEMBERS: int = 6;
const ROWS: int = 2;
const COLS: int = 3;

@onready var slots_container: Node2D = $Slots;

var grid: Array[Unit] = [];

@export var unit_scene: PackedScene;
@export var peasant: unitData;
@export var archer: unitData;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	grid.resize(ROWS*COLS);
	grid.fill(null);
	spawn_unit(peasant, 0,0);
	spawn_unit(archer, 0,1);
	spawn_unit(peasant, 0,2);
	spawn_unit(archer, 1,0);
	spawn_unit(peasant, 1,1);
	spawn_unit(peasant, 1,2);
	
func _get_index(row: int, col: int) -> int:
	return row * COLS + col
	
func get_slot_position(row: int, col: int) -> Vector2:
	var index = _get_index(row, col)
	var marker = slots_container.get_child(index) as Marker2D
	return marker.global_position
	
func place_unit(unit:Unit, row: int, col: int) -> bool:
	var index = _get_index(row, col)
	if grid[index] != null:
		print ("Slot occupied")
		return false
		
	grid[index] = unit
	unit.global_position = get_slot_position(row,col)
	return true

func spawn_unit(data: unitData, row: int, col: int) -> void:
	var new_unit: Unit = unit_scene.instantiate()
	
	place_unit(new_unit, row, col);
	add_child(new_unit)
	
	new_unit.setup(data)
