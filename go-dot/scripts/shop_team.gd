extends Node2D
class_name shop_team

const MAX_MEMBERS: int = 6;
const ROWS: int = 2;
const COLS: int = 3;

const MAX_HEALTH: int = 1000;

@onready var slots_container: Node2D = $Slots;

var grid: Array[shop_unit] = [];

@export var enemy: bool = false;
@export var unit_scene: PackedScene;
@export var peasant: unitData;
@export var archer: unitData;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	grid.resize(ROWS*COLS);
	grid.fill(null);

func export_team_data() -> Array[unitData]:
	var exported: Array[unitData] = []
	exported.resize(MAX_MEMBERS)
	exported.fill(null)
	
	for i in range(MAX_MEMBERS):
		if grid[i] != null:
			exported[i] = grid[i].unit_data
			
	return exported
		
func import_team_data(data_array: Array[unitData]) -> void:
	for i in range(MAX_MEMBERS):
		if grid[i] != null:
			delete_unit(i)
			
	for i in range(MAX_MEMBERS):
		var data = data_array[i]
		if data != null:
			var row = i / COLS
			var col = i % COLS
			spawn_unit(data,row,col)
	return
	
func _get_index(row: int, col: int) -> int:
	if(enemy):
		return row * COLS + (2-col) 
	else:
		return row * COLS + col
	
func get_slot_position(row: int, col: int) -> Vector2:
	var index = _get_index(row, col)
	var marker = slots_container.get_child(index) as Marker2D
	return marker.position
	
func place_unit(unit:shop_unit, row: int, col: int) -> bool:
	var index = _get_index(row, col)
	if grid[index] != null:
		print ("Slot occupied")
		return false
		
	grid[index] = unit
	
	unit.slot_index = index
	
	if enemy:
		unit.flip()

	unit.position = get_slot_position(row,col)
	return true
	
func spawn_unit(data: unitData, row: int, col: int) -> void:
	print("Spawning unit: ", data, " at row: ", row, " col: ", col)
	
	var new_unit: shop_unit = unit_scene.instantiate()
	
	add_child(new_unit)
	place_unit(new_unit, row, col);
	new_unit.setup(data)
	
	print("Unit spawned at position: ", new_unit.position, " global: ", new_unit.global_position)

	
func delete_unit(i: int) -> void:
	if is_instance_valid(grid[i]):
		grid[i].queue_free()
	grid[i] = null
