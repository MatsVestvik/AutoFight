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
@onready var camera_2d: Camera2D = $Camera2D
@onready var background: Node2D = $Background

const EMPTY_TROPHY = preload("uid://brfg5n1ap3kos")
const FULL_TROPHY = preload("uid://new5kku4yju7")
const WINDOW_TEX = preload("uid://c7wdobmop0s4q")
const CUSTOM_BUTTON = preload("uid://doufp6qhtjpie")
const GREEN_BTN = preload("uid://buyskdebcsedc")
const YELLOW_BTN = preload("uid://uokr206a6yig")
const FONT = preload("uid://c2h8gscc2qba0")

var trophys_array: Array[Sprite2D] = []

func _ready() -> void:
	trophys_array = [trophy_1, trophy_2, trophy_3, trophy_4, trophy_5, trophy_6, trophy_7, trophy_8, trophy_9, trophy_10]
	var current_wins: int = GameManager.wins
	set_trophys(current_wins)
	await get_tree().create_timer(1.0).timeout
	set_trophys(current_wins + 1)
	GameManager.on_battle_won()
	if GameManager.wins >= GameManager.TARGET_WINS and not GameManager.is_endless_mode:
		SoundManager.play_sfx(SoundManager.LEVEL_UP)
		await get_tree().create_timer(1.2).timeout
		_show_victory_screen()
	else:
		await get_tree().create_timer(2.0).timeout
		get_tree().change_scene_to_file("res://scenes/places/shop.tscn")

func set_trophys(trophys: int) -> void:
	if trophys_array.is_empty():
		trophys_array = [trophy_1, trophy_2, trophy_3, trophy_4, trophy_5, trophy_6, trophy_7, trophy_8, trophy_9, trophy_10]
	for j in range(trophys_array.size()):
		trophys_array[j].texture = EMPTY_TROPHY

	for i in range(mini(trophys, trophys_array.size())):
		trophys_array[i].texture = FULL_TROPHY

func _show_victory_screen() -> void:
	camera_2d.zoom = Vector2(2, 2)
	background.scale = Vector2(3, 3)

	for i in range(trophys_array.size()):
		trophys_array[i].scale = Vector2(1.5, 1.5)
		trophys_array[i].position = Vector2(-108.0 + float(i) * 24.0, -112.0)

	var win_sprite := Sprite2D.new()
	win_sprite.texture = WINDOW_TEX
	win_sprite.position = Vector2(0, 16)
	win_sprite.scale = Vector2(1.4, 1.5)
	add_child(win_sprite)

	var title := Label.new()
	title.text = "YOU WIN!"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.position = Vector2(-120, -64)
	title.size = Vector2(240, 32)
	title.add_theme_font_override("font", FONT)
	title.add_theme_font_size_override("font_size", 28)
	title.add_theme_color_override("font_color", Color(1.0, 0.85, 0.2, 1.0))
	title.add_theme_color_override("font_outline_color", Color.BLACK)
	title.add_theme_constant_override("outline_size", 4)
	add_child(title)

	var subtitle := Label.new()
	subtitle.text = "10 Trophies Reached!"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.position = Vector2(-120, -34)
	subtitle.size = Vector2(240, 24)
	subtitle.add_theme_font_override("font", FONT)
	subtitle.add_theme_font_size_override("font_size", 16)
	subtitle.add_theme_color_override("font_outline_color", Color.BLACK)
	subtitle.add_theme_constant_override("outline_size", 3)
	add_child(subtitle)

	var endless_btn: Button = CUSTOM_BUTTON.instantiate()
	endless_btn.label_name = "Endless Mode"
	endless_btn.image = GREEN_BTN
	endless_btn.position = Vector2(-112, 8)
	add_child(endless_btn)
	endless_btn.pressed.connect(func() -> void:
		GameManager.is_endless_mode = true
		get_tree().change_scene_to_file("res://scenes/places/shop.tscn")
	)

	var new_game_btn: Button = CUSTOM_BUTTON.instantiate()
	new_game_btn.label_name = "New Game"
	new_game_btn.image = GREEN_BTN
	new_game_btn.position = Vector2(-32, 8)
	add_child(new_game_btn)
	new_game_btn.pressed.connect(func() -> void:
		GameManager.reset_game()
		get_tree().change_scene_to_file("res://scenes/places/shop.tscn")
	)

	var menu_btn: Button = CUSTOM_BUTTON.instantiate()
	menu_btn.label_name = "Main Menu"
	menu_btn.image = YELLOW_BTN
	menu_btn.position = Vector2(48, 8)
	add_child(menu_btn)
	menu_btn.pressed.connect(func() -> void:
		GameManager.reset_game()
		get_tree().change_scene_to_file("res://scenes/places/start_screen.tscn")
	)
