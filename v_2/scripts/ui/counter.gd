extends TextureRect
class_name Counter

@onready var label: Label = $Label

const BURN_COUNTER = preload("uid://c1m7llyoq8jbt")
const NORMAL_COUNTER = preload("uid://o8lq16a6cuv2")
const POISON_COUNTER = preload("uid://dau4tpe0qb7e")
const SHIELD_COUNTER = preload("uid://b5aygn8265a34")

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
		Damage.Type.BURN:
			texture = BURN_COUNTER

func update_amount(new_amount: int) -> void:
	amount = new_amount
	if label:
		label.text = str(amount)

func _ready() -> void:
	label.text = str(amount)
