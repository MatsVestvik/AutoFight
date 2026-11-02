extends Node2D

@onready var settings: PanelContainer = get_node_or_null("Settings")
@onready var unit_pack_view: PanelContainer = get_node_or_null("UnitPackView")

func _on_new_game_button_pressed() -> void:
	GameManager.reset_game()
	get_tree().change_scene_to_file("res://scenes/places/shop.tscn")

func _on_unit_pack_button_pressed() -> void:
	if unit_pack_view:
		unit_pack_view.visible = not unit_pack_view.visible
		if unit_pack_view.visible and settings:
			settings.visible = false

func _on_settings_button_pressed() -> void:
	if settings:
		settings.visible = not settings.visible
		if settings.visible and unit_pack_view:
			unit_pack_view.visible = false

func _on_quit_button_pressed() -> void:
	get_tree().quit()
