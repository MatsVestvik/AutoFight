extends Node2D

@export var layer_0_speed: float = 10.0
@export var layer_1_speed: float = 25.0
@export var layer_2_speed: float = 40.0
@export var layer_2_spacing_multiplier: float = 6.0

@onready var layer_0: Node2D = $Layer0
@onready var layer_1: Node2D = $Layer1
@onready var layer_2: Node2D = $Layer2
@onready var layer_3: Sprite2D = $Layer3

func _ready() -> void:
	_setup_layer(layer_0, 1.0)
	_setup_layer(layer_1, 1.0)
	_setup_layer(layer_2, layer_2_spacing_multiplier)

func _process(delta: float) -> void:
	_scroll_layer(layer_0, layer_0_speed, delta, 1.0)
	_scroll_layer(layer_1, layer_1_speed, delta, 1.0)
	_scroll_layer(layer_2, layer_2_speed, delta, layer_2_spacing_multiplier)

func _setup_layer(layer: Node2D, spacing_multiplier: float = 1.0) -> void:
	var sprite_a: Sprite2D = layer.get_node("SpriteA")
	var sprite_b: Sprite2D = layer.get_node("SpriteB")
	if sprite_a.texture:
		var spacing: float = sprite_a.texture.get_height() * sprite_a.scale.y * spacing_multiplier
		sprite_a.position = Vector2.ZERO
		sprite_b.position = Vector2(0.0, spacing)

func _scroll_layer(layer: Node2D, speed: float, delta: float, spacing_multiplier: float = 1.0) -> void:
	var sprite_a: Sprite2D = layer.get_node("SpriteA")
	var sprite_b: Sprite2D = layer.get_node("SpriteB")
	if not sprite_a.texture:
		return

	var texture_height: float = sprite_a.texture.get_height() * sprite_a.scale.y
	var spacing: float = texture_height * spacing_multiplier

	sprite_a.position.y -= speed * delta
	sprite_b.position.y -= speed * delta

	if sprite_a.position.y <= -texture_height:
		sprite_a.position.y = sprite_b.position.y + spacing

	if sprite_b.position.y <= -texture_height:
		sprite_b.position.y = sprite_a.position.y + spacing
