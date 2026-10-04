extends superUnit

class_name shop_unit

var is_dragging: bool = false
var original_pos: Vector2
var slot_index: int = -1

@onready var selected: AnimatedSprite2D = $Selected

signal buy(data:unitData)
signal drag_started(unit:shop_unit)
signal drag_ended(unit:shop_unit)
signal hover(unit:disk_unit)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	selected.hide()
	selected.z_index = 1
	_connect_signal()

func _connect_signal() -> void:
	if not button_down.is_connected(_on_button_down):
		button_down.connect(_on_button_down)
	if not button_up.is_connected(_on_button_up):
		button_up.connect(_on_button_up)
	if not mouse_entered.is_connected(_on_mouse_entered):
		mouse_entered.connect(_on_mouse_entered)
	if not mouse_exited.is_connected(_on_mouse_exited):
		mouse_exited.connect(_on_mouse_exited)
		
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
	
func _on_mouse_entered() -> void:
	selected.show()
	hover.emit(self)
	
func _on_pressed() -> void:
	if is_dragging:
		is_dragging = false
		z_index = 0
		drag_ended.emit(self)
	buy.emit(self)

func reset_position() -> void:
	var tween = create_tween()
	tween.tween_property(self, "position", original_pos, 0.15).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
func _on_mouse_exited() -> void:
	selected.hide()
