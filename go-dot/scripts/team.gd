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
	health_bar.set_health(MAX_HEALTH)
	setup_trigger_view()

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
	
signal unit_triggered_signal(damage: int)

func take_damage(damage: int) -> void:
	health_bar.take_damage(damage)
	
func spawn_unit(data: unitData, row: int, col: int) -> void:
	var new_unit: Unit = unit_scene.instantiate()
	
	add_child(new_unit)
	place_unit(new_unit, row, col);


	_connect_unit(new_unit)
	
	new_unit.setup(data)
