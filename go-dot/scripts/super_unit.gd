extends Button
class_name superUnit

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var stats_container: Node2D = $StatsContainer

var current_timer: float = 0.0
var unit_data = unitData

signal trigger_signal (unit:Unit)

func _ready() -> void:
	return
	
func setup(data:unitData) -> void:
	unit_data = data.duplicate()
	sprite_2d.texture = data.sprite;
	stats_container.create_from_unit_data(data)

func trigger() -> void:
	trigger_signal.emit(self)
	GameManager.coins += unit_data.income
	var tween = create_tween()
	tween.tween_property(self, "position:y", position.y - 12.0, 0.08).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position:y", position.y, 0.12).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	print(unit_data.unit_name, " triggered")
	
