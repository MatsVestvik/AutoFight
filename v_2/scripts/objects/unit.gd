extends TextureButton
class_name Unit

@onready var sprite_2d: Sprite2D = $Sprite2D

var data: UnitData
var current_slot: UnitSlot = null
	
func _get_drag_data(_at_position: Vector2) -> Variant:
	var preview := TextureRect.new()
	preview.texture = sprite_2d.texture
	preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview.size = size

	var preview_container := Control.new()
	preview.position = -size / 2.0
	preview_container.add_child(preview)
	set_drag_preview(preview_container)
	
	modulate.a = 0.3
	
	return self

func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		modulate.a = 1.0
		
func create_from_data(input_data: UnitData) -> void:
	data = input_data
	sprite_2d.texture = data.texture
