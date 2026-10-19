extends Node2D

@onready var shop_team: Team = $ShopTeam
@onready var panel: PanelContainer = $SellZone
@onready var info_box: PanelContainer = $InfoBox

const SHOPUNIT = preload("uid://27hqy1duy2r")
	
func _ready() -> void:
	shop_team.load_team(GameManager.team)
	info_box.hide()
	
func _on_custom_button_pressed() -> void:
	GameManager.team = shop_team.get_team_data()
	get_tree().change_scene_to_file("res://scenes/places/arena.tscn")

func _on_disk_buy(data: UnitData, disk_unit: DiskUnit) -> void:
	if GameManager.coins < data.cost or shop_team.is_full():
		SoundManager.play_sfx(SoundManager.ERROR)
		return

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

func _on_sell_zone_unit_sold(unit: ShopUnit) -> void:
	SoundManager.play_sfx(SoundManager.SOLD)
	if unit.data:
		GameManager.add_coins(unit.data.cost / 2)
	# Trigger ON_SELL right before freeing
	var context := AbilityContext.new(unit, shop_team)
	unit.trigger_abilities(Ability.Trigger.ON_SELL, context)
	unit.queue_free()

