extends PanelContainer
class_name UnitSlot

@export var allow_drop: bool = true
@onready var center_container: CenterContainer = $CenterContainer
@onready var selected: AnimatedSprite2D = $Selected

const UNIT = preload("uid://cgpp4qmna44x2")

func _ready() -> void:
	selected.hide()
	if not mouse_entered.is_connected(_on_mouse_entered):
		mouse_entered.connect(_on_mouse_entered)
		mouse_exited.connect(_on_mouse_exited)
	
func clear_slot() -> void:
	var unit: Unit = get_unit()
	if unit:
		unit.queue_free()
	
func get_unit() -> Unit:
	for child in center_container.get_children():
		if child is Unit:
			return child
	return null

func is_empty() -> bool:
	return get_unit() == null

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if not allow_drop:
		return false
	return data is Unit

func _drop_data(_at_position: Vector2, new_unit: Variant) -> void:
	if not (new_unit is Unit):
		return

	var old_unit: Unit = get_unit()
	var origin_slot: UnitSlot = new_unit.current_slot

	if is_empty():
		_reparent_unit(new_unit)

	elif origin_slot == self:
		new_unit.modulate.a = 1.0

	else:
		if origin_slot != null:
			origin_slot._reparent_unit(old_unit)
		_reparent_unit(new_unit)

func _reparent_unit(unit: Unit) -> void:
	if unit.get_parent():
		unit.get_parent().remove_child(unit)
	
	center_container.add_child(unit)
	unit.current_slot = self
	unit.modulate.a = 1.0
	
func _on_mouse_entered() -> void:
	selected.show()
	if get_viewport().gui_is_dragging():
		return

	var unit: Unit = get_unit()
	if unit and unit.data:
		GameManager.unit_hovered.emit(unit.data)
	else:
		GameManager.unit_unhovered.emit()

func _on_mouse_exited() -> void:
	selected.hide()
	GameManager.unit_unhovered.emit()
