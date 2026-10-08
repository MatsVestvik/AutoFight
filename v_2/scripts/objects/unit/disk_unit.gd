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
const EPIC_BOX = preload("uid://cmj6y4t46htt")
const UNCOMMON_BOX = preload("uid://bt33foqyc0126")

signal buy(data:UnitData, disk_unit:DiskUnit)

func _ready() -> void:
	super._ready()
	_update_cost()
	_update_rarity_box()
	_update_typing()

func create_from_data(input_data: UnitData) -> void:
	data = input_data
	get_node("Sprite2D").texture = data.texture
	if is_node_ready():
		_update_cost()
		_update_stats()
		_update_rarity_box()
		_update_typing()

func _update_cost() -> void:
	if data and label:
		label.text = str(data.cost)
		
func _on_pressed() -> void:
	buy.emit(data, self)

func get_color(typing: UnitData.TYPING) -> Color:
	var color: Color
	match typing:
		
		UnitData.TYPING.FIRE:
			color = Color(1.0, 0.396, 0.122, 1.0)
		UnitData.TYPING.WATER:
			color = Color(0.212, 0.518, 1.0, 1.0)
		UnitData.TYPING.GRASS:
			color = Color(0.059, 0.878, 0.259, 1.0)
		UnitData.TYPING.FLYING:
			color = Color(0.596, 0.863, 1.0, 1.0)
		UnitData.TYPING.STEEL:
			color = Color(0.437, 0.547, 0.851, 1.0)
		UnitData.TYPING.DRAGON:
			color = Color(0.439, 0.545, 1.0, 1.0)
	return color
	
func _update_typing() -> void:
	if !data or !typing_1:
		return
		
	var color_1: Color
	var color_2: Color
	
	if data.typing.size() == 0:
		color_1 = Color()
		color_2 = Color()
	elif data.typing.size() == 1:
		color_1 = get_color(data.typing[0])
		color_2 = get_color(data.typing[0])
	elif data.typing.size() == 2:
		color_1 = get_color(data.typing[0])
		color_2 = get_color(data.typing[1])
	else:
		color_1 = Color(0.0, 0.885, 0.604, 1.0)
		color_2 = Color(0.0, 0.885, 0.604, 1.0)
		
	typing_1.color = color_1
	typing_2.color = color_2
	
func _update_rarity_box() -> void:
	if !data or !rarity_box:
		return

	match data.rarity:
		UnitData.RARITY.COMMON:
			rarity_box.texture = COMMON_BOX
		UnitData.RARITY.UNCOMMON:
			rarity_box.texture = UNCOMMON_BOX
		UnitData.RARITY.RARE:
			rarity_box.texture = RARE_BOX
		UnitData.RARITY.EPIC:
			rarity_box.texture = EPIC_BOX
		UnitData.RARITY.LEGENDARY:
			rarity_box.texture = LEGENDARY_BOX
		UnitData.RARITY.MYTHICAL:
			rarity_box.texture = MYTHICAL_BOX
	
