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
	# 1. Remove and free existing counters
	for child in stats.get_children():
		stats.remove_child(child)
		child.queue_free()
		
	# 2. Re-create only the stats the unit actually has
	if data.attack > 0:
		var counter = COUNTER.instantiate()
		stats.add_child(counter)
		counter.setup(Damage.Type.NORMAL, data.attack)
		
	if data.poison > 0:
		var counter = COUNTER.instantiate()
		stats.add_child(counter)
		counter.setup(Damage.Type.POISON, data.poison)

	if data.shield > 0:
		var counter = COUNTER.instantiate()
		stats.add_child(counter)
		counter.setup(Damage.Type.SHIELD, data.shield)
	
	if data.burn > 0:
		var counter = COUNTER.instantiate()
		stats.add_child(counter)
		counter.setup(Damage.Type.BURN, data.burn)
