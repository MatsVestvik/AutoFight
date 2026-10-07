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
	# Attempt to add to team
	var success: bool = shop_team.add_member(data)
	
	if success:
		disk_unit.queue_free()
	else:
		# Team was full: unit stays on the disk
		print("Team is full, could not purchase!")

func _on_sell_zone_unit_sold(unit: ShopUnit) -> void:
	unit.queue_free()
