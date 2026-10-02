extends ProgressBar

@onready var health_bar: ProgressBar = $"."
@onready var stats_container: Node2D = $StatsContainer

var health: int
var poison: int = 0
var burn: int = 0
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	pass # Replace with function body.
	
func set_health(added_health: int) -> void:
	health = added_health
	health_bar.max_value = health
	
func take_damage(damage: int) -> void:
	health -= damage
	health_bar.value = health

func apply_poison(added_poison:int) -> void:
	poison += added_poison
	stats_container.
	
func apply_burn(added_burn: int) -> void:
	burn += added_burn
