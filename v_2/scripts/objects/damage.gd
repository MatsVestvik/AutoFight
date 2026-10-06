class_name Damage
extends RefCounted

enum Type {
	NORMAL,
	POISON,
	SHOCK,
	BURN,
	SHIELD
}

var amount: int = 0
var type: Type = Type.NORMAL
var source: Node = null

func _init(p_amount: int = 0, p_type: Type = Type.NORMAL, p_source: Node = null) -> void:
	amount = p_amount
	type = p_type
	source = p_source
