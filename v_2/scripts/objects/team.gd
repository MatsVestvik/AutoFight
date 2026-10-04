extends GridContainer

@onready var unit_slot_1: UnitSlot = $UnitSlot
@onready var unit_slot_2: UnitSlot = $UnitSlot2
@onready var unit_slot_3: UnitSlot = $UnitSlot3
@onready var unit_slot_4: UnitSlot = $UnitSlot4
@onready var unit_slot_5: UnitSlot = $UnitSlot5
@onready var unit_slot_6: UnitSlot = $UnitSlot6

const UNIT = preload("uid://cgpp4qmna44x2")

func _ready() -> void:
	var new_unit = UNIT.instantiate()
	unit_slot_1._reparent_unit(new_unit)
	new_unit.create_from_data(GameManager.units[0])

	var new_unit_2 = UNIT.instantiate()
	unit_slot_2._reparent_unit(new_unit_2)
	new_unit_2.create_from_data(GameManager.units[1])
	
	var new_unit_3 = UNIT.instantiate()
	unit_slot_3._reparent_unit(new_unit_3)
	new_unit_3.create_from_data(GameManager.units[2])
	
