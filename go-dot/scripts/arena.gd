extends Node2D

@onready var team: Node2D = $Team
@onready var team_2: Node2D = $Team2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect_team(team)
	connect_team(team_2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func connect_team(team: Node2D) -> void:
	team.unit_triggered_signal.connect(attack)
	return
	
func attack(damage: int) -> void:
	team.take_damage(damage)
	return
