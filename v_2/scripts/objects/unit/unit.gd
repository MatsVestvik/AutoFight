extends TextureButton
class_name Unit

const COUNTER = preload("uid://colq0x8oeonmx")

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var stats: HBoxContainer = $Stats

var data: UnitData
var current_slot: UnitSlot = null

var attack_counter: Counter
var poison_counter: Counter
var shield_counter: Counter
var burn_counter: Counter

func _ready() -> void:
	if data:
		_update_stats()
	
func create_from_data(input_data: UnitData) -> void:
	data = input_data
	get_node("Sprite2D").texture = data.texture
	if is_node_ready():
		_update_stats()

func _update_stats() -> void:
	if data.attack > 0:
		if attack_counter == null:
			attack_counter = COUNTER.instantiate()
			stats.add_child(attack_counter)
			attack_counter.setup(Damage.Type.NORMAL, data.attack)
		else:
			attack_counter.update_amount(data.attack)
	elif attack_counter != null:
		attack_counter.queue_free()
		attack_counter = null
		
	if data.poison > 0:
		if poison_counter == null:
			poison_counter = COUNTER.instantiate()
			stats.add_child(poison_counter)
			poison_counter.setup(Damage.Type.POISON, data.poison)
		else:
			poison_counter.update_amount(data.poison)
	elif poison_counter != null:
		poison_counter.queue_free()
		poison_counter = null

	if data.shield > 0:
		if shield_counter == null:
			shield_counter = COUNTER.instantiate()
			stats.add_child(shield_counter)
			shield_counter.setup(Damage.Type.SHIELD, data.shield)
		else:
			shield_counter.update_amount(data.shield)
	elif shield_counter != null:
		shield_counter.queue_free()
		shield_counter = null
	
	if data.burn > 0:
		if burn_counter == null:
			burn_counter = COUNTER.instantiate()
			stats.add_child(burn_counter)
			burn_counter.setup(Damage.Type.BURN, data.burn)
		else:
			burn_counter.update_amount(data.burn)
	elif burn_counter != null:
		burn_counter.queue_free()
		burn_counter = null
