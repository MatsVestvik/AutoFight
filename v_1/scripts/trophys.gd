extends Node2D
class_name Trophys

@onready var trophy_1: Sprite2D = $Trophy_1
@onready var trophy_2: Sprite2D = $Trophy_2
@onready var trophy_3: Sprite2D = $Trophy_3
@onready var trophy_4: Sprite2D = $Trophy_4
@onready var trophy_5: Sprite2D = $Trophy_5
@onready var trophy_6: Sprite2D = $Trophy_6
@onready var trophy_7: Sprite2D = $Trophy_7
@onready var trophy_8: Sprite2D = $Trophy_8
@onready var trophy_9: Sprite2D = $Trophy_9
@onready var trophy_10: Sprite2D = $Trophy_10


const EMPTY_TROPHY = preload("uid://co6qj42k5i2s1")
const FULL_TROPHY = preload("uid://dxd7oocqhjd7b")

var trophys_array: Array[Sprite2D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	trophys_array = [trophy_1,trophy_2,trophy_3,trophy_4,trophy_5,trophy_6,trophy_7,trophy_8,trophy_9,trophy_10]
	set_trophys(GameManager.trophys)

func set_trophys(trophys:int) -> void:
	if trophys_array.is_empty():
		trophys_array = [trophy_1,trophy_2,trophy_3,trophy_4,trophy_5,trophy_6,trophy_7,trophy_8,trophy_9,trophy_10]
	for j in range(trophys_array.size()):
		trophys_array[j].texture = EMPTY_TROPHY
				
	for i in range(trophys):
		trophys_array[i].texture = FULL_TROPHY
		
func _process(delta: float) -> void:
	pass
