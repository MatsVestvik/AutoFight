extends Node2D

@onready var shop_team: Team = $ShopTeam
@onready var bench_grid: GridContainer = $GridContainer
@onready var panel: PanelContainer = $SellZone
@onready var info_box: PanelContainer = $InfoBox

const SHOPUNIT = preload("res://scenes/objects/unit/shop_unit.tscn")
	
func _ready() -> void:
	shop_team.load_team(GameManager.team)
	_load_bench(GameManager.bench)
	info_box.hide()
	
func _on_custom_button_pressed() -> void:
	GameManager.team = shop_team.get_team_data()
	GameManager.bench = _get_bench_data()
	get_tree().change_scene_to_file("res://scenes/places/arena.tscn")

func _get_bench_slots() -> Array[UnitSlot]:
	var bench_slots: Array[UnitSlot] = []
	for child in bench_grid.get_children():
		if child is UnitSlot:
			bench_slots.append(child)
	return bench_slots

func _load_bench(bench_data: Array[UnitData]) -> void:
	var bench_slots: Array[UnitSlot] = _get_bench_slots()
	for i in range(mini(bench_data.size(), bench_slots.size())):
		var data: UnitData = bench_data[i]
		if data != null:
			var slot: UnitSlot = bench_slots[i]
			if not slot.is_empty():
				slot.clear_slot()
			var new_unit: ShopUnit = SHOPUNIT.instantiate()
			new_unit.create_from_data(data)
			slot._reparent_unit(new_unit)

func _get_bench_data() -> Array[UnitData]:
	var result: Array[UnitData] = []
	for slot in _get_bench_slots():
		var unit: Unit = slot.get_unit()
		if unit != null:
			result.append(unit.data)
		else:
			result.append(null)
	return result

func _get_first_empty_bench_slot() -> UnitSlot:
	for slot in _get_bench_slots():
		if slot.is_empty():
			return slot
	return null

func _on_disk_buy(data: UnitData, disk_unit: DiskUnit) -> void:
	var empty_bench_slot: UnitSlot = _get_first_empty_bench_slot()
	if GameManager.coins < data.cost or (shop_team.is_full() and empty_bench_slot == null):
		SoundManager.play_sfx(SoundManager.ERROR)
		return

	if not shop_team.is_full():
		var success: bool = shop_team.add_member(data)
		if success:
			GameManager.spend_coins(data.cost)
			SoundManager.play_sfx(SoundManager.BUY)
			# Find the newly added unit and trigger ON_BUY
			var bought_unit: Unit = shop_team.get_last_added_unit()
			if bought_unit:
				var context := AbilityContext.new(bought_unit, shop_team)
				bought_unit.trigger_abilities(Ability.Trigger.ON_BUY, context)
			disk_unit.queue_free()
		else:
			SoundManager.play_sfx(SoundManager.ERROR)
	elif empty_bench_slot != null:
		var new_unit: ShopUnit = SHOPUNIT.instantiate()
		new_unit.create_from_data(data)
		empty_bench_slot._reparent_unit(new_unit)
		GameManager.spend_coins(data.cost)
		SoundManager.play_sfx(SoundManager.BUY)
		var context := AbilityContext.new(new_unit, shop_team)
		new_unit.trigger_abilities(Ability.Trigger.ON_BUY, context)
		disk_unit.queue_free()

func _on_sell_zone_unit_sold(unit: ShopUnit) -> void:
	SoundManager.play_sfx(SoundManager.SOLD)
	if unit.data:
		GameManager.add_coins(unit.data.cost / 2)
	# Trigger ON_SELL right before freeing
	var context := AbilityContext.new(unit, shop_team)
	unit.trigger_abilities(Ability.Trigger.ON_SELL, context)
	unit.queue_free()

