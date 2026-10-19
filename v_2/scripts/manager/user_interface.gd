extends Control

@onready var day_counter: Label = $DayCounter
@onready var health_counter: Label = $HealthCounter
@onready var wins_counter: Label = $WinsCounter
@onready var cash_counter: Label = $CashCounter

func _ready() -> void:
	GameManager.stats_changed.connect(_update_ui)
	_update_ui()

func _update_ui() -> void:
	day_counter.text = str(GameManager.day)
	cash_counter.text = str(GameManager.coins)
	health_counter.text = str(GameManager.health)
	wins_counter.text = str(GameManager.wins)

func _on_exit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/places/start_screen.tscn")
