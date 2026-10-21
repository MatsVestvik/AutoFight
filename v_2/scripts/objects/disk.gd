extends Node2D

@onready var custom_button: Button = $CustomButton
@onready var unit_slot_1: UnitSlot = $Slots/UnitSlot1
@onready var unit_slot_2: UnitSlot = $Slots/UnitSlot2
@onready var unit_slot_3: UnitSlot = $Slots/UnitSlot3
@onready var unit_slot_4: UnitSlot = $Slots/UnitSlot4
@onready var unit_slot_5: UnitSlot = $Slots/UnitSlot5
@onready var slots: HBoxContainer = $Slots

@onready var shop_level_label: Label = $Bar/Level
@onready var common_label: Label = $Bar/Common
@onready var uncommon_label: Label = $Bar/Uncommon
@onready var rare_label: Label = $Bar/Rare
@onready var epic_label: Label = $Bar/Epic
@onready var legendary_label: Label = $Bar/Legendary
@onready var level_sprite_1: Sprite2D = $Level
@onready var level_sprite_2: Sprite2D = $Level/Level
@onready var upgrade_cost_label: Label = $Level/UpgradeCost
@onready var upgrade_cash: Sprite2D = $Level/Cash
@onready var upgrade_button: Button = $Upgrade2
@onready var upgrade_sprite: Sprite2D = $Upgrade2/Sprite2D
@onready var upgrade_label: Label = $Upgrade2/Label

const DISK_UNIT = preload("uid://bu8jiidw7frlw")
const REROLL_COST: int = 1
const BUTTON_UP = preload("uid://bvd5x72oie3qf")
const BUTTON_HOVER = preload("uid://bx0l5m7c7qbyb")
const BUTTON_DOWN = preload("uid://chpfymtvsuwmu")

var upgrade_hovered: bool = false
var upgrade_down: bool = false

const LEVEL_TEXTURES: Array[Texture2D] = [
	preload("uid://c74fnp05yvrn3"), # level_0.png
	preload("uid://i402tdw23655"), # level_1.png
	preload("uid://yh5bofivopve"), # level_2.png
	preload("uid://bkpcbu6ixyvng"), # level_3.png
	preload("uid://csdbbciclusop"), # level_4.png
	preload("uid://bnl5m2ydkhxb2"), # level_5.png
	preload("uid://de3v23ghrpah1"), # level_6.png
	preload("uid://daadbfo6f2dlm"), # level_7.png
]

signal buy(data:UnitData, disk_unit: DiskUnit)

func _ready() -> void:
	GameManager.stats_changed.connect(_update_shop_level_ui)
	_update_shop_level_ui()
	reroll()
	
func reroll() -> void:
	for slot in slots.get_children():
		slot.clear_slot()
		var unit_data: UnitData = GameManager.get_random_unit_for_shop()
		if unit_data == null:
			continue
		var unit: DiskUnit = DISK_UNIT.instantiate()
		unit.create_from_data(unit_data)
		unit.buy.connect(_on_unit_buy)
		slot._reparent_unit(unit)

func _update_shop_level_ui() -> void:
	var lvl: int = GameManager.shop_level
	shop_level_label.text = "Level: " + str(lvl)

	var odds: Array = GameManager.get_shop_rarity_odds(lvl)
	common_label.text = str(odds[0]) + "%"
	uncommon_label.text = str(odds[1]) + "%"
	rare_label.text = str(odds[2]) + "%"
	epic_label.text = str(odds[3]) + "%"
	legendary_label.text = str(odds[4]) + "%"

	var left_bars: int = clampi(lvl, 0, 7)
	var right_bars: int = clampi(lvl - 7, 0, 7)
	level_sprite_1.texture = LEVEL_TEXTURES[left_bars]
	level_sprite_2.texture = LEVEL_TEXTURES[right_bars]

	if lvl >= GameManager.MAX_SHOP_LEVEL:
		upgrade_button.disabled = true
		upgrade_cost_label.text = "MAX"
		upgrade_cash.hide()
	else:
		upgrade_button.disabled = false
		upgrade_cost_label.text = str(GameManager.get_shop_upgrade_cost())
		upgrade_cash.show()

	_update_upgrade_button_visual()

func _update_upgrade_button_visual() -> void:
	if upgrade_button.disabled or upgrade_down:
		upgrade_sprite.texture = BUTTON_DOWN
		upgrade_label.position = Vector2(0, 8)
	elif upgrade_hovered:
		upgrade_sprite.texture = BUTTON_HOVER
		upgrade_label.position = Vector2(0, 2)
	else:
		upgrade_sprite.texture = BUTTON_UP
		upgrade_label.position = Vector2(0, 0)

func _on_unit_buy(data:UnitData, disk_unit:DiskUnit) -> void:
	buy.emit(data, disk_unit)
	
func _on_custom_button_pressed() -> void:
	if GameManager.spend_coins(REROLL_COST):
		reroll()
	else:
		SoundManager.play_sfx(SoundManager.ERROR)

func _on_upgrade_button_down() -> void:
	if not upgrade_button.disabled:
		upgrade_down = true
		_update_upgrade_button_visual()

func _on_upgrade_button_up() -> void:
	upgrade_down = false
	_update_upgrade_button_visual()

func _on_upgrade_pressed() -> void:
	if GameManager.upgrade_shop():
		SoundManager.play_sfx(SoundManager.LEVEL_UP)
		_update_shop_level_ui()
	else:
		SoundManager.play_sfx(SoundManager.ERROR)

func _on_upgrade_mouse_entered() -> void:
	upgrade_hovered = true
	if not upgrade_button.disabled:
		SoundManager.play_sfx(SoundManager.MOUSE_ENTERED)
	_update_upgrade_button_visual()

func _on_upgrade_mouse_exited() -> void:
	upgrade_hovered = false
	_update_upgrade_button_visual()
