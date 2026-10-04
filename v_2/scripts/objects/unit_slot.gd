extends PanelContainer
class_name UnitSlot

@onready var center_container: CenterContainer = $CenterContainer

const UNIT = preload("uid://cgpp4qmna44x2")

func _ready() -> void:
	pass
	
# Check if there is currently a unit child in the slot
func get_unit() -> Unit:
	for child in center_container.get_children():
		if child is Unit:
			return child
	return null

func is_empty() -> bool:
	return get_unit() == null

# 1. Godot asks: "Can this dragged item be dropped here?"
func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is Unit

# 2. Godot calls this when you release the mouse over this slot
func _drop_data(_at_position: Vector2, new_unit: Variant) -> void:
	if not (new_unit is Unit):
		return

	var old_unit: Unit = get_unit()
	var origin_slot: UnitSlot = new_unit.current_slot

	# SCENARIO A: The slot is empty
	if is_empty():
		_reparent_unit(new_unit)

	# SCENARIO B: Dropping onto the same slot it came from
	elif origin_slot == self:
		new_unit.modulate.a = 1.0

	# SCENARIO C: The slot is occupied -> Swap the two units
	else:
		if origin_slot != null:
			origin_slot._reparent_unit(old_unit)
		_reparent_unit(new_unit)

# Helper function to move a unit into this slot safely
func _reparent_unit(unit: Unit) -> void:
	if unit.get_parent():
		unit.get_parent().remove_child(unit)
	
	center_container.add_child(unit)
	unit.current_slot = self
	unit.modulate.a = 1.0
	
