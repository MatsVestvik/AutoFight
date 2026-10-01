extends Node2D
class_name Disk

@onready var slots: Array[Marker2D] = [$Slot_1, $Slot_2, $Slot_3, $Slot_4, $Slot_5]
@onready var button: Button = $Reroll

@export var unit_scene: PackedScene;
@export var disk_unit_scene: PackedScene;
@export var peasant: unitData;
@export var archer: unitData;

var row: Array[disk_unit] = []

signal hover(shop_unit)
signal buy(data:unitData)

func _ready() -> void:
	row.resize(5);
	row.fill(null);
	refresh_units()
	
func get_slot_position(index: int) -> Vector2:
	return slots[index].position
	
func refresh_units() -> void:
	clear_disk()
	for i in range(5):
		spawn_unit(GameManager.available_pool.pick_random(), i)
		
func clear_disk() -> void:
	for i in range(row.size()):
		if is_instance_valid(row[i]):
			row[i].queue_free()
		row[i] = null
	
func place_unit(unit:disk_unit, index: int) -> bool:
	if row[index] != null:
		print ("Slot occupied")
		return false
		
	row[index] = unit
	
	unit.position = get_slot_position(index)
	
	return true
	
func connect_unit(unit:shop_unit)->void:
	unit.buy.connect(_on_unit_pressed)
	unit.drag_started.connect(_on_unit_drag_started)
	unit.hover.connect(hover_unit)

func hover_unit(unit:disk_unit)-> void:
	hover.emit(unit)
	
func _on_unit_pressed(unit: shop_unit) -> void:
	
	var success: bool = false
	var shop = get_parent()
	success = shop.buy_unit(unit)
	if success:
		var index = row.find(unit)
		if index != -1:
			row[index] = null
		unit.queue_free()
	else:
		unit.reset_position()

func _on_unit_drag_started(unit: shop_unit) -> void:
	hover.emit(unit)
	
func on_unit_buy(unit: shop_unit) -> void:
	buy.emit(unit)
	
	var index = row.find(unit)
	if index != -1:
		row[index] = null
	
	unit.queue_free()
	
func spawn_unit(data: unitData, index: int) -> void:
	var new_unit: disk_unit = disk_unit_scene.instantiate()
	
	add_child(new_unit)
	connect_unit(new_unit)
	place_unit(new_unit, index);
	new_unit.setup(data)

func _on_reroll_pressed() -> void:
	refresh_units()
