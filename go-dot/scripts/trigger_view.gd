extends Node2D

const PIXEL_OPERATOR_8 = preload("uid://d2h3ynn7ql5ic")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func addTrigger(number: int, color: String) -> void:
	var label = Label.new()
	label.text = str(number)
	label.add_theme_font_override("font", PIXEL_OPERATOR_8)
	label.add_theme_font_size_override("font_size", 8)
	
	add_child(label)
	
	var random_x = randf_range(-10,10)
	var random_y = randf_range(-10,10)
	label.position = Vector2(random_x,random_y)
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property(label, "position:y", label.position.y - 50.0,2.0)
	tween.tween_property(label, "modulate:a", 0.0,2.0)
	
	tween.finished.connect(label.queue_free)
