extends Node2D

const MAX_MEMBERS = 6

var team_array: Array[unitData] = []

@export var shop_team_scene: PackedScene
@export var peasant: unitData;
@export var archer: unitData;

@onready var disk: Disk = $Disk
@onready var team_slot: Marker2D = $Team_Slot
@onready var sell_zone: Panel = $Sell_Zone

var active_team: shop_team
var grid: Array[Unit] = []

func _ready() -> void:
	team_array = GameManager.get_team()
	setup_team(team_array)
	connect_disk(disk)

func connect_team_units() -> void:
		for child in active_team.get_children():
			if child is shop_unit:
				_connect_unit(child)
	
func setup_team(unit_data: Array[unitData])->void:
	active_team = shop_team_scene.instantiate()
	add_child(active_team)
	
	active_team.import_team_data(unit_data)
	
	active_team.position = team_slot.position
	
	connect_team_units()

	return

func _on_battle_pressed() -> void:
	var team_to_save: Array[unitData] = active_team.export_team_data()
	
	GameManager.save_team(team_to_save)
	
	get_tree().change_scene_to_file("res://scenes/arena.tscn")

func connect_disk(disk:Disk)->void:
	disk.buy.connect(buy_unit)

func _connect_unit(u:shop_unit) -> void:
	if not u.drag_ended.is_connected(_on_unit_drag_ended):
		u.drag_ended.connect(_on_unit_drag_ended)
	
func _on_unit_drag_ended (unit:shop_unit) -> void:
	var mouse_pos: Vector2 = get_global_mouse_position()
	
	if sell_zone.get_global_rect().has_point(mouse_pos):
		print("selling")
		sell_unit(unit)
	else:
		unit.reset_position()
		
func sell_unit(unit: shop_unit) -> void:
	var current_team: Array[unitData] = active_team.export_team_data()
	
	if unit.slot_index != -1 and unit.slot_index < current_team.size():
		current_team[unit.slot_index] = null
		
	active_team.import_team_data(current_team)
	connect_team_units()
	
func buy_unit(data:unitData) -> bool:
	if not active_team:
		return false
	
	var current_team: Array[unitData] = active_team.export_team_data()
	var free_slot_index: int = current_team.find(null)
	
	if free_slot_index == -1:
		print("team full")
		return false
	current_team[free_slot_index] = data
	active_team.import_team_data(current_team)
	connect_team_units()
	
	print("Bought unit")
	return true
