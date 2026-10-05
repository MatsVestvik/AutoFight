extends Unit
class_name ShopUnit


func _get_drag_data(_at_position: Vector2) -> Variant:

	modulate.a = 0.3

	var preview_unit: Unit = load("res://scenes/objects/unit/shop_unit.tscn").instantiate()
	preview_unit.position = -size / 2.0

	preview_unit.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var preview_container := Control.new()
	preview_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	preview_container.add_child(preview_unit)
	set_drag_preview(preview_container)

	if data:
		preview_unit.create_from_data(data)
	preview_unit.get_node("AnimationPlayer").play("picked_up")

	return self

func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		modulate.a = 1.0

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if current_slot:
		return current_slot._can_drop_data(at_position, data)
	return false

func _drop_data(at_position: Vector2, data: Variant) -> void:
	if current_slot:
		current_slot._drop_data(at_position, data)
