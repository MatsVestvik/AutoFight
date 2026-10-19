extends Node2D

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

const EMPTY_HEART = preload("uid://cllu24vif3ccs")
const FULL_HEART = preload("uid://cl4rinq8o4etw")

var hearts_array: Array[Sprite2D] = []

func _ready() -> void:
	hearts_array = [heart_1, heart_2, heart_3, heart_4, heart_5, heart_6, heart_7, heart_8, heart_9, heart_10]
	var current_health: int = GameManager.health
	set_hearts(current_health)
	await get_tree().create_timer(1.0).timeout
	set_hearts(maxi(0, current_health - 1))
	GameManager.on_battle_lost()
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://scenes/places/shop.tscn")

func set_hearts(health: int) -> void:
	if hearts_array.is_empty():
		hearts_array = [heart_1, heart_2, heart_3, heart_4, heart_5, heart_6, heart_7, heart_8, heart_9, heart_10]
	for j in range(hearts_array.size()):
		hearts_array[j].texture = EMPTY_HEART

	for i in range(mini(health, hearts_array.size())):
		hearts_array[i].texture = FULL_HEART
