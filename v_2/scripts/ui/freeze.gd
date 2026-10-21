extends Button

const LONG_NORMAL = preload("uid://bvd5x72oie3qf")
const LONG_HOVER = preload("uid://bx0l5m7c7qbyb")
const LONG_PRESSED = preload("uid://chpfymtvsuwmu")

@onready var frozen: PanelContainer = $Frozen
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var label: Label = $Label

var toggled_freeze: bool = false
var is_hovered: bool = false

func _on_pressed() -> void:
	toggled_freeze = !toggled_freeze
	SoundManager.play_sfx(SoundManager.CLICK)
	_update_visual()

func _on_mouse_entered() -> void:
	is_hovered = true
	SoundManager.play_sfx(SoundManager.MOUSE_ENTERED)
	_update_visual()

func _on_mouse_exited() -> void:
	is_hovered = false
	_update_visual()

func _update_visual() -> void:
	if toggled_freeze:
		sprite_2d.texture = LONG_PRESSED
		label.position = Vector2(0, 8)
		frozen.show()
	elif is_hovered:
		sprite_2d.texture = LONG_HOVER
		label.position = Vector2(0, 2)
		frozen.hide()
	else:
		sprite_2d.texture = LONG_NORMAL
		label.position = Vector2(0, 0)
		frozen.hide()
