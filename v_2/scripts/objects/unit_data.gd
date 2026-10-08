extends Resource
class_name UnitData
enum RARITY {
	COMMON,
	UNCOMMON,
	RARE,
	EPIC,
	LEGENDARY,
	MYTHICAL
}
enum TYPING {
	FIRE,
	WATER,
	GRASS,
	FLYING,
	STEEL,
	DRAGON
}

@export var texture: Texture2D
@export var name: String = ""
@export var cooldown_time: float
@export var cost: int
@export var level: int
@export var rarity: RARITY
@export var typing: Array[TYPING] = []
@export var abilities: Array[Ability] = []
@export var attack: int
@export var poison: int
@export var shield: int
@export var burn: int
