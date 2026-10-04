extends TextureButton
class_name Unit

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var data: UnitData
var current_slot: UnitSlot = null

func _get_drag_data(_at_position: Vector2) -> Variant:
	# 1. Dim the ghost left in the slot (it continues playing its normal idle animation)
	modulate.a = 0.3

	# 2. Instantiate a copy of the unit to follow the mouse
	var preview_unit: Unit = load("res://scenes/objects/unit.tscn").instantiate()
	preview_unit.position = -size / 2.0
	# Important: ignore mouse clicks so it doesn't block dropping onto the slots underneath
	preview_unit.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var preview_container := Control.new()
	preview_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	preview_container.add_child(preview_unit)
	set_drag_preview(preview_container)

	# 3. Setup the preview unit and play picked_up on it!
	if data:
		preview_unit.create_from_data(data)
	preview_unit.get_node("AnimationPlayer").play("picked_up")

	return self

func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		modulate.a = 1.0

func create_from_data(input_data: UnitData) -> void:
	data = input_data
	# Use get_node so it works even before the node enters the scene tree
	get_node("Sprite2D").texture = data.texture
