extends Node2D

const MAX_MEMBERS: int = 6;
const ROWS: int = 2;
const COLS: int = 3;

const MAX_HEALTH: int = 1000;

@onready var slots_container: Node2D = $Slots;
@onready var trigger_view: Node2D = $TriggerView
@onready var health_bar: ProgressBar = $HealthBar

var grid: Array[Unit] = [];
@export var enemy: bool = false;

@export var unit_scene: PackedScene;
@export var peasant: unitData;
@export var archer: unitData;

signal unit_triggered_signal(damage: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	grid.resize(ROWS*COLS);
	grid.fill(null);
	health_bar.set_health(MAX_HEALTH)
	setup_trigger_view()

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
			var row = i/COLS
			var col = i% COLS
			spawn_unit(data,row,col)
	return
	
func setup_trigger_view() -> void:
	if(enemy):
		trigger_view.position.x = -trigger_view.position.x
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
	
func place_unit(unit:Unit, row: int, col: int) -> bool:
	var index = _get_index(row, col)
	if grid[index] != null:
		print ("Slot occupied")
		return false
		
	grid[index] = unit
	
	if enemy:
		unit.flip()

	unit.position = get_slot_position(row,col)
	return true

func _connect_unit(u:Unit) -> void:
	u.attack_signal.connect(_on_unit_triggered)

func _on_unit_triggered(amount: int, color_name: String) -> void:
	trigger_view.addTrigger(amount, color_name)
	unit_triggered_signal.emit(amount)

func take_damage(damage: int) -> void:
	health_bar.take_damage(damage)
	
func spawn_unit(data: unitData, row: int, col: int) -> void:
	print("Spawning unit: ", data, " at row: ", row, " col: ", col)
	
	var new_unit: Unit = unit_scene.instantiate()
	
	add_child(new_unit)
	place_unit(new_unit, row, col);
	_connect_unit(new_unit)
	new_unit.setup(data)
	
	print("Unit spawned at position: ", new_unit.position, " global: ", new_unit.global_position)
	
	
	
func delete_unit(i: int) -> void:
	remove_child(grid[i])
	grid[i].queue_free()
	grid[i] = null
