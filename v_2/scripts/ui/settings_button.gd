extends Button

const HOVER_SETTINGS = preload("uid://b673yo0ik18nj")
const SETTINGS = preload("uid://bvtqcdwdk8qox")

@onready var settings: PanelContainer = $Settings


func _on_mouse_entered() -> void:
	icon = HOVER_SETTINGS


func _on_mouse_exited() -> void:
	icon = SETTINGS


func _on_pressed() -> void:
	settings.visible = not settings.visible
