extends Node2D

@onready var custom_button: Button = $CustomButton
@onready var unit_slot_1: UnitSlot = $Slots/UnitSlot1
@onready var unit_slot_2: UnitSlot = $Slots/UnitSlot2
@onready var unit_slot_3: UnitSlot = $Slots/UnitSlot3
@onready var unit_slot_4: UnitSlot = $Slots/UnitSlot4
@onready var unit_slot_5: UnitSlot = $Slots/UnitSlot5
@onready var slots: HBoxContainer = $Slots

const DISK_UNIT = preload("uid://bu8jiidw7frlw")

signal buy(data:UnitData, disk_unit: DiskUnit)

func _ready() -> void:
	reroll()
	
func reroll() -> void:
	for slot in slots.get_children():
		slot.clear_slot()
		var unit: DiskUnit = DISK_UNIT.instantiate()
		unit.create_from_data(GameManager.get_all_unit_data().pick_random())
		unit.buy.connect(_on_unit_buy)
		slot._reparent_unit(unit)

func _on_unit_buy(data:UnitData, disk_unit:DiskUnit) -> void:
	buy.emit(data, disk_unit)
	
func _on_custom_button_pressed() -> void:
	reroll()
