extends Node2D
class_name Hearts

@onready var heart_1: Sprite2D = $Heart_1
@onready var heart_2: Sprite2D = $Heart_2
@onready var heart_3: Sprite2D = $Heart_3
@onready var heart_4: Sprite2D = $Heart_4
@onready var heart_5: Sprite2D = $Heart_5
@onready var heart_6: Sprite2D = $Heart_6
@onready var heart_7: Sprite2D = $Heart_7
@onready var heart_8: Sprite2D = $Heart_8
@onready var heart_9: Sprite2D = $Heart_9
@onready var heart_10: Sprite2D = $Heart_10

const EMPTY_HEART = preload("uid://cdlvww64485hp")
const FULL_HEART = preload("uid://fhk42btdvtg4")

var hearts_array: Array[Sprite2D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hearts_array = [heart_1,heart_2,heart_3,heart_4,heart_5,heart_6,heart_7,heart_8,heart_9,heart_10]
	set_hearts(GameManager.hearts)

func set_hearts(health:int) -> void:
	if hearts_array.is_empty():
		hearts_array = [heart_1, heart_2, heart_3, heart_4, heart_5, heart_6, heart_7, heart_8, heart_9, heart_10]
	for j in range(hearts_array.size()):
		hearts_array[j].texture = EMPTY_HEART
		
	for i in range(health):
		hearts_array[i].texture = FULL_HEART
		
func _process(delta: float) -> void:
	pass
