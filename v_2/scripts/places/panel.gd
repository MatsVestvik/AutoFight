extends PanelContainer
class_name SellZone

signal unit_sold(unit: ShopUnit)

@onready var label: Label = $Label

func _ready() -> void:
	hide()
	GameManager.unit_hovered.connect(_on_unit_hovered)
	GameManager.unit_unhovered.connect(_on_unit_unhovered)

func _on_unit_hovered(unit_data: UnitData) -> void:
	if unit_data:
		_set_sell_price(unit_data.cost / 2)

func _on_unit_unhovered() -> void:
	if not get_viewport().gui_is_dragging() and label:
		label.text = "Sell"

func _set_sell_price(price: int) -> void:
	if label:
		label.text = "Sell ($" + str(price) + ")"

func _notification(what: int) -> void:
	# Godot automatically notifies all Control nodes when drag starts or ends
	if what == NOTIFICATION_DRAG_BEGIN:
		var drag_data: Variant = get_viewport().gui_get_drag_data()
		if drag_data is ShopUnit and drag_data.data:
			_set_sell_price(drag_data.data.cost / 2)
		show()
	elif what == NOTIFICATION_DRAG_END:
		if label:
			label.text = "Sell"
		hide()

# 1. Only allow dropping units from our team (ShopUnit)
func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if data is ShopUnit and data.data:
		_set_sell_price(data.data.cost / 2)
	return data is ShopUnit

# 2. Called when the unit is released over the SellZone
func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if data is ShopUnit:
		unit_sold.emit(data)
