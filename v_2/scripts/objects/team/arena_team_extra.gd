extends Node2D
class_name ArenaTeamExtra

signal health_changed(current_hp: int, max_hp: int)
signal shield_changed(current_shield: int)
signal damage_taken(damage: Damage)
signal defeated()
signal team_attacked(damage: Damage)

@export var max_health: int = 100

@onready var arena_team: Team = $ArenaTeam
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var Effects: HBoxContainer = $Effects

const COUNTER = preload("uid://colq0x8oeonmx")

var current_health: int = 100
var poison: int = 0
var shield: int = 0

var poison_counter: Counter
var shield_counter: Counter

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_health = max_health
	_update_progress_bar()
	arena_team.unit_attacked.connect(func(damage:Damage): team_attacked.emit(damage))
	
func take_damage(damage: Damage) -> void:
	if current_health <= 0:
		return

	var remaining_damage: int = damage.amount

	match damage.type:
		Damage.Type.NORMAL:
			# Shield absorbs normal damage first
			if shield > 0:
				var absorbed: int = mini(shield, remaining_damage)
				shield -= absorbed
				remaining_damage -= absorbed
				shield_changed.emit(shield)
			
			current_health = maxi(0, current_health - remaining_damage)
			
		Damage.Type.POISON:
			poison += damage.amount
		Damage.Type.SHIELD:
			shield += damage.amount

	_update_progress_bar()
	_update_effects()
	health_changed.emit(current_health, max_health)
	damage_taken.emit(damage)

	if current_health <= 0:
		defeated.emit()

func add_shield(amount: int) -> void:
	shield += amount
	shield_changed.emit(shield)

func add_poison(stacks: int) -> void:
	poison += stacks

func _update_progress_bar() -> void:
	if progress_bar:
		progress_bar.max_value = max_health
		progress_bar.value = current_health

func _update_effects() -> void:
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

# 2. Handle Shield Counter
	if shield > 0:
		if shield_counter == null:
			shield_counter = COUNTER.instantiate()
			Effects.add_child(shield_counter)
			shield_counter.setup(Damage.Type.SHIELD, shield)
		else:
			shield_counter.update_amount(shield)
	elif shield_counter != null:
		shield_counter.queue_free()
		shield_counter = null
