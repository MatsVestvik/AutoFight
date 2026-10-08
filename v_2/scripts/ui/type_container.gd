extends TextureRect
class_name TypeContainer

const DRAGON_BOX = preload("uid://b36ibow3kfqld")
const FIRE_BOX = preload("uid://2kh8oh6i0wu1")
const GRASS_BOX = preload("uid://c1s6mnjun2mf4")
const NORMAL_BOX = preload("uid://ci6v1atcnlqir")
const WATER_BOX = preload("uid://bjhduk1x8vvlo")

@onready var typing_sprite: TypeContainer = $"."
@onready var label: Label = $Label

@export var typing:UnitData.TYPING

func _ready() -> void:
	pass
	
func set_typing(p_typing:UnitData.TYPING) -> void:
	match p_typing:
		UnitData.TYPING.DRAGON: typing_sprite.texture = DRAGON_BOX; label.text = "DRAGON"
		UnitData.TYPING.FIRE: typing_sprite.texture = FIRE_BOX; label.text = "FIRE"
		UnitData.TYPING.GRASS: typing_sprite.texture = GRASS_BOX; label.text = "GRASS"
		UnitData.TYPING.WATER: typing_sprite.texture = WATER_BOX; label.text = "WATER"
	
func _process(delta: float) -> void:
	pass
