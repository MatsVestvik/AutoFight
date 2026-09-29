extends superUnit

class_name shop_unit

var is_dragging: bool = false
var original_pos: Vector2
var slot_index: int = -1

signal buy(data:unitData)
signal drag_started(unit:shop_unit)
signal drag_ended(unit:shop_unit)
signal info(unit:shop_unit)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_down.connect(_on_button_down)
	button_up.connect(_on_button_up)

func _process(_delta: float) -> void:
	if is_dragging:
		global_position = get_global_mouse_position()-(size/2.0)
		

func _on_button_down() -> void:
	is_dragging = true
	original_pos = position
	z_index = 50
	drag_started.emit(self)
	
func _on_button_up() -> void:
	if is_dragging:
		is_dragging = false
		z_index = 0
		drag_ended.emit(self)
	
func _on_pressed() -> void:
	if is_dragging:
		is_dragging = false
		z_index = 0
		drag_ended.emit(self)
	buy.emit(self)
	

func reset_position() -> void:
	var tween = create_tween()
	tween.tween_property(self, "position", original_pos, 0.15).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
