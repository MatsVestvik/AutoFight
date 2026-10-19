extends Node2D

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

const EMPTY_TROPHY = preload("uid://brfg5n1ap3kos")
const FULL_TROPHY = preload("uid://new5kku4yju7")

var trophys_array: Array[Sprite2D] = []

func _ready() -> void:
	trophys_array = [trophy_1, trophy_2, trophy_3, trophy_4, trophy_5, trophy_6, trophy_7, trophy_8, trophy_9, trophy_10]
	var current_wins: int = GameManager.wins
	set_trophys(current_wins)
	await get_tree().create_timer(1.0).timeout
	set_trophys(current_wins + 1)
	GameManager.on_battle_won()
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://scenes/places/shop.tscn")

func set_trophys(trophys: int) -> void:
	if trophys_array.is_empty():
		trophys_array = [trophy_1, trophy_2, trophy_3, trophy_4, trophy_5, trophy_6, trophy_7, trophy_8, trophy_9, trophy_10]
	for j in range(trophys_array.size()):
		trophys_array[j].texture = EMPTY_TROPHY

	for i in range(mini(trophys, trophys_array.size())):
		trophys_array[i].texture = FULL_TROPHY
