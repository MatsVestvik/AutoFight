extends PanelContainer
class_name SellZone

signal unit_sold(unit: ShopUnit)

func _ready() -> void:
	hide()

func _notification(what: int) -> void:
	# Godot automatically notifies all Control nodes when drag starts or ends
	if what == NOTIFICATION_DRAG_BEGIN:
		show()
	elif what == NOTIFICATION_DRAG_END:
		hide()

# 1. Only allow dropping units from our team (ShopUnit)
func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is ShopUnit

# 2. Called when the unit is released over the SellZone
func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if data is ShopUnit:
		unit_sold.emit(data)
