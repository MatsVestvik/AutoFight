extends PanelContainer
class_name InfoBox

@onready var name_label: Label = $MarginContainer/VBoxContainer/Name
@onready var sprite_2d: Sprite2D = $MarginContainer/VBoxContainer/Sprite2D
@onready var stats: VBoxContainer = $MarginContainer/VBoxContainer/Sprite2D/VBoxContainer
@onready var cooldown_timer: Label = $MarginContainer/VBoxContainer/Sprite2D/CooldownTimer

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
	_update_cooldown()
	name_label.text = unit_data.name
	if unit_data.texture:
		sprite_2d.texture = unit_data.texture
	show()

func clear() -> void:
	hide()

func _update_cooldown() -> void:
	cooldown_timer.text = str(data.cooldown_time) + " S"
	
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
