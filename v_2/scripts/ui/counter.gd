extends TextureRect
class_name Counter

@onready var label: Label = $Label

const NORMAL_COUNTER = preload("uid://b0cwvf030bk1n")
const POISON_COUNTER = preload("uid://b362s856vmsmr")
const SHIELD_COUNTER = preload("uid://bmhbjsunp8wr5")

var type: Damage.Type
var amount: int

func setup(p_type: Damage.Type, p_amount: int) -> void:
	type = p_type
	update_amount(p_amount)
	
	match type:
		Damage.Type.NORMAL:
			texture = NORMAL_COUNTER
		Damage.Type.POISON:
			texture = POISON_COUNTER
		Damage.Type.SHIELD:
			texture = SHIELD_COUNTER

func update_amount(new_amount: int) -> void:
	amount = new_amount
	if label:
		label.text = str(amount)

func _ready() -> void:
	label.text = str(amount)
