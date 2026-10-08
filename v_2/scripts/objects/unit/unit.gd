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

var active_counters: Dictionary = {}
	
signal stats_changed(unit:Unit)

func _ready() -> void:
	if data:
		_update_stats()

func trigger_abilities(trigger_type: Ability.Trigger, context: AbilityContext) -> void:
	if data == null:
		return
	for ability in data.abilities:
		if ability.can_trigger(trigger_type):
			ability.execute(context)

func create_from_data(input_data: UnitData) -> void:
	# Duplicate data so buffs on this unit don't mutate other units!
	data = input_data.duplicate()
	$Sprite2D.texture = data.texture
	if is_node_ready():
		_update_stats()

## Apply a stat buff or debuff
func apply_buff(stat_type: Ability.StatType, amount: int) -> void:
	if data == null:
		return

	var damage_type: Damage.Type
	var old_val: int = 0
	var new_val: int = 0

	match stat_type:
		Ability.StatType.ATTACK:
			damage_type = Damage.Type.NORMAL
			data.attack = maxi(0, data.attack + amount)
			new_val = data.attack
		Ability.StatType.POISON:
			damage_type = Damage.Type.POISON
			data.poison = maxi(0, data.poison + amount)
			new_val = data.poison
		Ability.StatType.SHIELD:
			damage_type = Damage.Type.SHIELD
			data.shield = maxi(0, data.shield + amount)
			new_val = data.shield
		Ability.StatType.BURN:
			damage_type = Damage.Type.BURN
			data.burn = maxi(0, data.burn + amount)
			new_val = data.burn

	# 1. Update the visual counter on the unit
	_set_counter_value(damage_type, new_val)

	# 2. Spawn floating text (e.g., "+2")
	_show_floating_buff(amount, damage_type)

	# 3. Notify listeners (like InfoBox)
	stats_changed.emit(self)

## Refreshes all counters
func _update_stats() -> void:
	_set_counter_value(Damage.Type.NORMAL, data.attack)
	_set_counter_value(Damage.Type.POISON, data.poison)
	_set_counter_value(Damage.Type.SHIELD, data.shield)
	_set_counter_value(Damage.Type.BURN, data.burn)

## Updates an existing counter, creates one if needed, or removes it if 0
func _set_counter_value(type: Damage.Type, value: int) -> void:
	if value > 0:
		if active_counters.has(type) and is_instance_valid(active_counters[type]):
			var counter: Counter = active_counters[type]
			counter.update_amount(value)
			_punch_counter(counter)
		else:
			var counter: Counter = COUNTER.instantiate()
			stats.add_child(counter)
			counter.setup(type, value)
			active_counters[type] = counter
			_punch_counter(counter)
	else:
		if active_counters.has(type) and is_instance_valid(active_counters[type]):
			active_counters[type].queue_free()
			active_counters.erase(type)

## Quick pop/bounce animation when a stat is buffed
func _punch_counter(counter: Counter) -> void:
	var tween = create_tween()
	counter.pivot_offset = counter.size / 2.0
	tween.tween_property(counter, "scale", Vector2(1.3, 1.3), 0.08).set_trans(Tween.
TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(counter, "scale", Vector2(1.0, 1.0), 0.12).set_trans(Tween.
TRANS_BOUNCE).set_ease(Tween.EASE_OUT)

## Floating number animation above the unit
func _show_floating_buff(amount: int, type: Damage.Type) -> void:
	var label = Label.new()
	label.text = ("+" if amount > 0 else "") + str(amount)
	label.add_theme_font_size_override("font_size", 12)
	
	# Color code by stat
	match type:
		Damage.Type.NORMAL: label.modulate = Color(1.0, 0.4, 0.4) # Red
		Damage.Type.SHIELD: label.modulate = Color(0.4, 0.8, 1.0) # Blue
		Damage.Type.POISON: label.modulate = Color(0.4, 1.0, 0.4) # Green
		Damage.Type.BURN:   label.modulate = Color(1.0, 0.6, 0.2) # Orange

	add_child(label)
	label.position = Vector2(size.x / 4.0, -10.0)

	var tween = create_tween().set_parallel(true)
	tween.tween_property(label, "position:y", label.position.y - 25.0, 0.8).set_trans(Tween.
TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(label, "modulate:a", 0.0, 0.8).set_delay(0.2)
	tween.chain().tween_callback(label.queue_free)
