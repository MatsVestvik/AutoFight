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
@onready var camera_2d: Camera2D = $Camera2D
@onready var background: Node2D = $Background

const EMPTY_HEART = preload("uid://cllu24vif3ccs")
const FULL_HEART = preload("uid://cl4rinq8o4etw")
const WINDOW_TEX = preload("uid://c7wdobmop0s4q")
const CUSTOM_BUTTON = preload("uid://doufp6qhtjpie")
const GREEN_BTN = preload("uid://buyskdebcsedc")
const YELLOW_BTN = preload("uid://uokr206a6yig")
const FONT = preload("uid://c2h8gscc2qba0")

var hearts_array: Array[Sprite2D] = []

func _ready() -> void:
	hearts_array = [heart_1, heart_2, heart_3, heart_4, heart_5, heart_6, heart_7, heart_8, heart_9, heart_10]
	var current_health: int = GameManager.health
	set_hearts(current_health)
	await get_tree().create_timer(1.0).timeout
	set_hearts(maxi(0, current_health - 1))
	GameManager.on_battle_lost()
	if GameManager.health <= 0:
		SoundManager.play_sfx(SoundManager.ERROR)
		await get_tree().create_timer(1.2).timeout
		_show_game_over_screen()
	else:
		await get_tree().create_timer(2.0).timeout
		get_tree().change_scene_to_file("res://scenes/places/shop.tscn")

func set_hearts(health: int) -> void:
	if hearts_array.is_empty():
		hearts_array = [heart_1, heart_2, heart_3, heart_4, heart_5, heart_6, heart_7, heart_8, heart_9, heart_10]
	for j in range(hearts_array.size()):
		hearts_array[j].texture = EMPTY_HEART

	for i in range(mini(health, hearts_array.size())):
		hearts_array[i].texture = FULL_HEART

func _show_game_over_screen() -> void:
	camera_2d.zoom = Vector2(2, 2)
	background.scale = Vector2(3, 3)

	for i in range(hearts_array.size()):
		hearts_array[i].scale = Vector2(1.5, 1.5)
		hearts_array[i].position = Vector2(-108.0 + float(i) * 24.0, -112.0)

	var win_sprite := Sprite2D.new()
	win_sprite.texture = WINDOW_TEX
	win_sprite.position = Vector2(0, 16)
	win_sprite.scale = Vector2(1.2, 1.5)
	add_child(win_sprite)

	var title := Label.new()
	title.text = "GAME OVER"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.position = Vector2(-120, -64)
	title.size = Vector2(240, 32)
	title.add_theme_font_override("font", FONT)
	title.add_theme_font_size_override("font_size", 28)
	title.add_theme_color_override("font_color", Color(1.0, 0.3, 0.3, 1.0))
	title.add_theme_color_override("font_outline_color", Color.BLACK)
	title.add_theme_constant_override("outline_size", 4)
	add_child(title)

	var subtitle := Label.new()
	subtitle.text = "Wins: " + str(GameManager.wins) + "  |  Day: " + str(GameManager.day)
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.position = Vector2(-120, -34)
	subtitle.size = Vector2(240, 24)
	subtitle.add_theme_font_override("font", FONT)
	subtitle.add_theme_font_size_override("font_size", 16)
	subtitle.add_theme_color_override("font_outline_color", Color.BLACK)
	subtitle.add_theme_constant_override("outline_size", 3)
	add_child(subtitle)

	var new_game_btn: Button = CUSTOM_BUTTON.instantiate()
	new_game_btn.label_name = "New Game"
	new_game_btn.image = GREEN_BTN
	new_game_btn.position = Vector2(-72, 8)
	add_child(new_game_btn)
	new_game_btn.pressed.connect(func() -> void:
		GameManager.reset_game()
		get_tree().change_scene_to_file("res://scenes/places/shop.tscn")
	)

	var menu_btn: Button = CUSTOM_BUTTON.instantiate()
	menu_btn.label_name = "Main Menu"
	menu_btn.image = YELLOW_BTN
	menu_btn.position = Vector2(8, 8)
	add_child(menu_btn)
	menu_btn.pressed.connect(func() -> void:
		GameManager.reset_game()
		get_tree().change_scene_to_file("res://scenes/places/start_screen.tscn")
	)
