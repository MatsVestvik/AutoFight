extends Button

const HOVER_SETTINGS = preload("uid://b673yo0ik18nj")
const SETTINGS = preload("uid://bvtqcdwdk8qox")

@onready var settings: PanelContainer = $Settings


func _on_mouse_entered() -> void:
	SoundManager.play_sfx(SoundManager.MOUSE_ENTERED)
	icon = HOVER_SETTINGS


func _on_mouse_exited() -> void:
	icon = SETTINGS


func _on_pressed() -> void:
	SoundManager.play_sfx(SoundManager.CLICK)
	settings.visible = not settings.visible
	if settings.visible:
		var unit_pack_node := get_parent().get_node_or_null("UnitPackButton/UnitPackView")
		if unit_pack_node is CanvasItem:
			unit_pack_node.visible = false
