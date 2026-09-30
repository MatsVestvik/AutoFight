extends Node2D
class_name Disk

@onready var slots: Array[Marker2D] = [$Slot_1, $Slot_2, $Slot_3, $Slot_4, $Slot_5]
@onready var buy_zone: Panel = $Buy_Zone
@onready var button: Button = $Reroll

@export var unit_scene: PackedScene;
@export var shop_unit_scene: PackedScene;
@export var peasant: unitData;
@export var archer: unitData;

var row: Array[shop_unit] = []

signal info(shop_unit)
signal buy(data:unitData)

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
	
func refresh_units() -> void:
	clear_disk()
	for i in range(5):
		var unit: shop_unit = shop_unit_scene.instantiate()
		spawn_unit(GameManager.available_pool.pick_random(), i)
		
func clear_disk() -> void:
	for i in range(row.size()):
		if is_instance_valid(row[i]):
			row[i].queue_free()
		row[i] = null
	
func place_unit(unit:shop_unit, index: int) -> bool:
	if row[index] != null:
		print ("Slot occupied")
		return false
		
	row[index] = unit
	
	unit.position = get_slot_position(index)
	
	return true
	

func connect_unit(unit:shop_unit)->void:
	unit.drag_ended.connect(_on_unit_drag_ended)
	unit.drag_started.connect(_on_unit_drag_started)

func _on_unit_drag_ended(unit: shop_unit) -> void:
	var mouse_pos: Vector2 = get_global_mouse_position()
	
	if buy_zone.get_global_rect().has_point(mouse_pos):
		on_unit_buy(unit)
	unit.reset_position()

func _on_unit_drag_started(unit: shop_unit) -> void:
	info.emit(unit)
	
func on_unit_buy(unit: shop_unit) -> void:
	buy.emit(unit)
	
	var index = row.find(unit)
	if index != -1:
		row[index] = null
	
	unit.queue_free()
	
func spawn_unit(data: unitData, index: int) -> void:
	var new_unit: shop_unit = shop_unit_scene.instantiate()
	
	add_child(new_unit)
	connect_unit(new_unit)
	place_unit(new_unit, index);
	new_unit.setup(data)

func _on_reroll_pressed() -> void:
	refresh_units()
