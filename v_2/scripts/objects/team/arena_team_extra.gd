extends Node2D
class_name ArenaTeamExtra

signal health_changed(current_hp: int, max_hp: int)
signal shield_changed(current_shield: int)
signal damage_taken(damage: Damage)
signal defeated()
signal team_attacked(damage: Damage)

const COUNTER = preload("uid://colq0x8oeonmx")
const POISON_TICK_INTERVAL: float = 1.0
const BURN_TICK_INTERVAL: float = 0.5

@export var max_health: int = 100
@export var enemy: bool = false

@onready var arena_team: Team = $ArenaTeam
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var Effects: HBoxContainer = $Effects
@onready var shield_sprite: Sprite2D = $Shield
@onready var shield_label: Label = $Shield/Label

var current_health: int = 100
var poison: int = 0
var burn: int = 0
var shield: int = 0

var poison_timer: float = 0.0
var burn_timer: float = 0.0

var poison_counter: Counter
var burn_counter: Counter

func _ready() -> void:
	arena_team.enemy = enemy
	current_health = max_health
	_update_progress_bar()
	_update_shield()
	arena_team.unit_attacked.connect(_on_unit_attacked)

func _process(delta: float) -> void:
	if current_health <= 0:
		return

	if poison > 0:
		poison_timer += delta
		if poison_timer >= POISON_TICK_INTERVAL:
			poison_timer -= POISON_TICK_INTERVAL
			_apply_damage_to_health(poison)
	else:
		poison_timer = 0.0

	if current_health <= 0:
		return

	if burn > 0:
		burn_timer += delta
		if burn_timer >= BURN_TICK_INTERVAL:
			burn_timer -= BURN_TICK_INTERVAL
			var burn_damage: int = burn
			burn = maxi(0, burn - 1)
			_apply_damage_to_health(burn_damage)
	else:
		burn_timer = 0.0

func _on_unit_attacked(damage: Damage) -> void:
	if damage == null or damage.amount <= 0:
		return
	if damage.type == Damage.Type.SHIELD:
		add_shield(damage.amount)
	else:
		team_attacked.emit(damage)

func take_damage(damage: Damage) -> void:
	if current_health <= 0 or damage == null or damage.amount <= 0:
		return

	match damage.type:
		Damage.Type.NORMAL, Damage.Type.SHOCK:
			_apply_damage_to_health(damage.amount)
		Damage.Type.POISON:
			add_poison(damage.amount)
		Damage.Type.BURN:
			add_burn(damage.amount)
		Damage.Type.SHIELD:
			add_shield(damage.amount)

	damage_taken.emit(damage)

func _apply_damage_to_health(amount: int) -> void:
	if current_health <= 0 or amount <= 0:
		return

	var remaining_damage: int = amount
	if shield > 0:
		var absorbed: int = mini(shield, remaining_damage)
		shield -= absorbed
		remaining_damage -= absorbed
		shield_changed.emit(shield)
		_update_shield()

	if remaining_damage > 0:
		current_health = maxi(0, current_health - remaining_damage)
		health_changed.emit(current_health, max_health)

	_update_progress_bar()
	_update_effects()

	if current_health <= 0:
		defeated.emit()

func add_shield(amount: int) -> void:
	shield += amount
	shield_changed.emit(shield)
	_update_shield()

func add_poison(stacks: int) -> void:
	poison += stacks
	_update_effects()

func add_burn(stacks: int) -> void:
	burn += stacks
	_update_effects()

func _update_progress_bar() -> void:
	if progress_bar:
		progress_bar.max_value = max_health
		progress_bar.value = current_health

func _update_shield() -> void:
	if shield_label:
		shield_label.text = str(shield)

func _update_effects() -> void:
	# 1. Handle Poison Counter
	if poison > 0:
		if poison_counter == null:
			poison_counter = COUNTER.instantiate()
			Effects.add_child(poison_counter)
			poison_counter.setup(Damage.Type.POISON, poison)
		else:
			poison_counter.update_amount(poison)
	elif poison_counter != null:
		poison_counter.queue_free()
		poison_counter = null

	# 2. Handle Burn Counter
	if burn > 0:
		if burn_counter == null:
			burn_counter = COUNTER.instantiate()
			Effects.add_child(burn_counter)
			burn_counter.setup(Damage.Type.BURN, burn)
		else:
			burn_counter.update_amount(burn)
	elif burn_counter != null:
		burn_counter.queue_free()
		burn_counter = null
