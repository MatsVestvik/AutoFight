extends Resource
class_name UnitData
enum RARITY {
	COMMON,
	UNCOMMON,
	RARE,
	ULTRA_RARE,
	LEGENDARY,
	MYTHICAL
}

@export var texture: Texture2D
@export var name: String = ""
@export var cooldown_time: float
@export var cost: int
@export var level: int
@export var rarity: RARITY
@export var attack: int
@export var poison: int
@export var shield: int
@export var burn: int
