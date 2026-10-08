extends GridContainer
class_name Team

# Store references to all 6 slots in order
@onready var slots: Array[UnitSlot] = [
	$UnitSlot1,
	$UnitSlot2,
	$UnitSlot3,
	$UnitSlot4,
	$UnitSlot5,
	$UnitSlot6
]



func _ready() -> void:
	pass
	
func get_first_empty_slot() -> int:
	for i in range(slots.size()):
		if slots[i].is_empty():
			return i
	return -1

func is_full() -> bool:
	return get_first_empty_slot() == -1


	
func get_team_data() -> Array[UnitData]:
	var result: Array[UnitData] = []
	for slot in slots:
		var unit: Unit = slot.get_unit()
		if unit != null:
			result.append(unit.data)
		else:
			result.append(null)
	return result
