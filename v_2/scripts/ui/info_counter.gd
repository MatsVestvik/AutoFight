extends PanelContainer
class_name InfoCounter

@onready var label: Label = $Label
@onready var amount: Label = $Amount

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func setup(p_type:Damage.Type, p_amount:int) -> void:
	set_type(p_type)
	update_amount(p_amount)
	
func set_type(type:Damage.Type) -> void:
	label.text = str(type)

	var color: Color
	var type_name: String = ""

	match type:
		Damage.Type.NORMAL:
			type_name = "NORMAL"
			color = Color(1.0, 0.706, 0.384, 1.0)
		Damage.Type.POISON:
			type_name = "POISON"
			color = Color(0.61, 0.248, 0.725, 1.0)
		Damage.Type.BURN:
			type_name = "BURN"
			color = Color(0.827, 0.373, 0.0, 1.0)
		Damage.Type.SHIELD:
			type_name = "SHIELD"
			color = Color(0.542, 0.533, 0.811, 1.0)

	label.text = type_name
	var style_box := get_theme_stylebox("panel").duplicate() as StyleBoxFlat
	style_box.bg_color = color
	add_theme_stylebox_override("panel", style_box)
	
func update_amount(p_amount:int) -> void:
	amount.text = str(p_amount)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
