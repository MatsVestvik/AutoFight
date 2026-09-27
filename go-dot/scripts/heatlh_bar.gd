extends ProgressBar

@onready var health_bar: ProgressBar = $"."

var health: int
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	pass # Replace with function body.
	
func set_health(health: int) -> void:
	self.health = health
	health_bar.max_value = health
	
func take_damage(damage: int) -> void:
	health -= damage
	health_bar.value = health
