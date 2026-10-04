extends Node2D

@export var scroll_speed: float = 100.0 # Piksler per sekund

@onready var sprite_a: Sprite2D = $SpriteA
@onready var sprite_b: Sprite2D = $SpriteB

var texture_width: float = 0.0

func _ready() -> void:
	# 1. Hent bredden på teksturen
	if sprite_a.texture:
		texture_width = sprite_a.texture.get_width() * sprite_a.scale.x
	
	# 2. Plasser Sprite B rett etter Sprite A
	sprite_a.position.x = 0
	sprite_b.position.x = texture_width

func _process(delta: float) -> void:
	# 3. Flytt begge mot venstre
	sprite_a.position.x -= scroll_speed * delta
	sprite_b.position.x -= scroll_speed * delta
	
	# 4. Hvis en sprite forlater venstresiden, flytt den bak den andre
	if sprite_a.position.x <= -texture_width:
		sprite_a.position.x = sprite_b.position.x + texture_width
		
	if sprite_b.position.x <= -texture_width:
		sprite_b.position.x = sprite_a.position.x + texture_width
