extends PanelContainer
class_name InfoBox

@onready var name_label: Label = $MarginContainer/VBoxContainer/Name
@onready var sprite_2d: Sprite2D = $MarginContainer/VBoxContainer/Sprite2D
@onready var stats: VBoxContainer = $MarginContainer/VBoxContainer/Sprite2D/VBoxContainer

const COUNTER = preload("uid://c8ogbactqmb6w")

var data:UnitData

var attack_counter: InfoCounter
var poison_counter: InfoCounter
var shield_counter: InfoCounter
var burn_counter: InfoCounter

func _ready() -> void:
	hide()
	GameManager.unit_hovered.connect(display_unit)
	GameManager.unit_unhovered.connect(clear)

func display_unit(unit_data: UnitData) -> void:
	if unit_data == null:
		clear()
		return
	data = unit_data
	_update_stats()
	name_label.text = unit_data.name
	if unit_data.texture:
		sprite_2d.texture = unit_data.texture
	show()

func clear() -> void:
	hide()

func _update_stats() -> void:
	for child in stats.get_children():
		child.queue_free()
		
	if data.attack > 0:
		if attack_counter == null:
			attack_counter = COUNTER.instantiate()
			stats.add_child(attack_counter)
			attack_counter.setup(Damage.Type.NORMAL, data.attack)
		else:
			attack_counter.update_amount(data.attack)
		
	if data.poison > 0:
		if poison_counter == null:
			poison_counter = COUNTER.instantiate()
			stats.add_child(poison_counter)
			poison_counter.setup(Damage.Type.POISON, data.poison)
		else:
			poison_counter.update_amount(data.poison)

	if data.shield > 0:
		if shield_counter == null:
			shield_counter = COUNTER.instantiate()
			stats.add_child(shield_counter)
			shield_counter.setup(Damage.Type.SHIELD, data.shield)
		else:
			shield_counter.update_amount(data.shield)
	
	if data.burn > 0:
		if burn_counter == null:
			burn_counter = COUNTER.instantiate()
			stats.add_child(burn_counter)
			burn_counter.setup(Damage.Type.BURN, data.burn)
		else:
			burn_counter.update_amount(data.burn)
