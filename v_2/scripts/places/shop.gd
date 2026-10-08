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
	var success: bool = shop_team.add_member(data)
	if success:
		# Find the newly added unit and trigger ON_BUY
		var slot_idx: int = shop_team.get_first_empty_slot() - 1 # or track target slot
		# Or find the unit directly:
		var bought_unit: Unit = shop_team.get_last_added_unit()
		if bought_unit:
			var context := AbilityContext.new(bought_unit, shop_team)
			bought_unit.trigger_abilities(Ability.Trigger.ON_BUY, context)
		disk_unit.queue_free()

func _on_sell_zone_unit_sold(unit: ShopUnit) -> void:
	# Trigger ON_SELL right before freeing
	var context := AbilityContext.new(unit, shop_team)
	unit.trigger_abilities(Ability.Trigger.ON_SELL, context)
	unit.queue_free()
