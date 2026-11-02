extends Button

const HOVER_UNIT_PACK = preload("res://assets/icons/hover_unit_pack.png")
const UNIT_PACK = preload("res://assets/icons/unit_pack.png")

@onready var unit_pack_view: Control = $UnitPackView

func _on_mouse_entered() -> void:
	SoundManager.play_sfx(SoundManager.MOUSE_ENTERED)
	icon = HOVER_UNIT_PACK

func _on_mouse_exited() -> void:
	icon = UNIT_PACK

func _on_pressed() -> void:
	SoundManager.play_sfx(SoundManager.CLICK)
	unit_pack_view.visible = not unit_pack_view.visible
	if unit_pack_view.visible:
		var settings_node := get_parent().get_node_or_null("SettingsButton/Settings")
		if settings_node is CanvasItem:
			settings_node.visible = false
	else:
		GameManager.unit_unhovered.emit()
