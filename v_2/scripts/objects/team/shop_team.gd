extends Team

const SHOP_UNIT_SCENE = preload("res://scenes/objects/unit/shop_unit.tscn")

func load_team(team_data: Array[UnitData]) -> void:
	for i in range(team_data.size()):
		var data: UnitData = team_data[i]
		if data != null:
			add_member(data, i)
			
func add_member(data: UnitData, slot: int = -1) -> bool:
	if slot == -1:
		slot = get_first_empty_slot()
	
	if slot == -1 or slot >= slots.size():
		print("Cannot add member: Team is full or invalid slot!")
		return false
	
	var target_slot: UnitSlot = slots[slot]
	
	if not target_slot.is_empty():
		target_slot.clear_slot()

	var new_unit: ShopUnit = SHOP_UNIT_SCENE.instantiate()
	new_unit.create_from_data(data)

	target_slot._reparent_unit(new_unit)
	
	return true
