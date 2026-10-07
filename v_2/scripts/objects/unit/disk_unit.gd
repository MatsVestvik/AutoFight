extends Unit
class_name DiskUnit

@onready var cash: Sprite2D = $Cash
@onready var label: Label = $Cash/Label
@onready var typing_1: ColorRect = $Typing1
@onready var typing_2: ColorRect = $Typing2
@onready var rarity_box: Sprite2D = $RarityBox

const COMMON_BOX = preload("uid://xvyo27i13lt")
const LEGENDARY_BOX = preload("uid://by8mopl6jft7d")
const MYTHICAL_BOX = preload("uid://ducaakyxwhjjc")
const RARE_BOX = preload("uid://47j0a13jth5")
const ULTRA_RARE_BOX = preload("uid://bialmymt2wh7p")
const UNCOMMON_BOX = preload("uid://bt33foqyc0126")

signal buy(data:UnitData, disk_unit:DiskUnit)

func _ready() -> void:
	super._ready()
	_update_cost()
	_update_rarity_box()

func create_from_data(input_data: UnitData) -> void:
	data = input_data
	get_node("Sprite2D").texture = data.texture
	if is_node_ready():
		_update_cost()
		_update_stats()
		_update_rarity_box()

func _update_cost() -> void:
	if data and label:
		label.text = str(data.cost)
		
func _on_pressed() -> void:
	buy.emit(data, self)

func _update_rarity_box() -> void:
	if !data or !rarity_box:
		return

	match data.RARITY:
		UnitData.RARITY.COMMON:
			rarity_box.texture = COMMON_BOX
		UnitData.RARITY.UNCOMMON:
			rarity_box.texture = UNCOMMON_BOX
		UnitData.RARITY.RARE:
			rarity_box.texture = RARE_BOX
		UnitData.RARITY.ULTRA_RARE:
			rarity_box.texture = ULTRA_RARE_BOX
		UnitData.RARITY.LEGENDARY:
			rarity_box.texture = LEGENDARY_BOX
		UnitData.RARITY.MYTHICAL:
			rarity_box.texture = MYTHICAL_BOX
	
