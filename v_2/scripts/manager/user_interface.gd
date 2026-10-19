extends Control

@onready var day_counter: Label = $DayCounter
@onready var health_counter: Label = $HealthCounter
@onready var wins_counter: Label = $WinsCounter
@onready var cash_counter: Label = $CashCounter

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	day_counter.text = str(GameManager.coins)
	health_counter.text = str(GameManager.health)
	wins_counter.text = str(GameManager.wins)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
