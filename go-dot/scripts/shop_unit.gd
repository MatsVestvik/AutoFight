extends Button

class_name shop_unit

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var attack: Label = $attack

var unit_data: unitData
var is_dragging: bool = false
var original_pos: Vector2
var slot_index: int = -1

signal buy(data:unitData)
signal drag_started(unit:shop_unit)
signal drag_ended(unit:shop_unit)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_down.connect(_on_button_down)
	button_up.connect(_on_button_up)
	pass # Replace with function body.

func _process(_delta: float) -> void:
	if is_dragging:
		global_position = get_global_mouse_position()-(size/2.0)
		
func setup(unit: unitData) -> void:
	unit_data = unit
	sprite_2d.texture = unit.sprite
	attack.text = str(unit.attack)
	return

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
		
	print("buying")
	buy.emit(unit_data)
