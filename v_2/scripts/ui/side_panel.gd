extends Node2D
class_name SidePanel

const OPEN_TEXTURE = preload("uid://cra12nepuo5pc")
const CLOSE_TEXTURE = preload("uid://b4ohdvkt5wroe")
const PANEL_WIDTH: float = 128.0

@export var start_open: bool = false

@onready var toggle_button: TextureButton = $ToggleButton
@onready var grid_container: GridContainer = $MarginContainer/GridContainer

var is_open: bool = false
var closed_x: float = 288.0
var _tween: Tween

func _ready() -> void:
	closed_x = position.x
	is_open = start_open
	_update_panel(false)

func toggle() -> void:
	is_open = not is_open
	_update_panel(true)

func _update_panel(animate: bool) -> void:
	var target_x: float = (closed_x - PANEL_WIDTH) if is_open else closed_x
	toggle_button.texture_normal = CLOSE_TEXTURE if is_open else OPEN_TEXTURE

	if _tween and _tween.is_valid():
		_tween.kill()

	if animate:
		_tween = create_tween()
		_tween.tween_property(self, "position:x", target_x, 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	else:
		position.x = target_x

func _on_toggle_button_pressed() -> void:
	SoundManager.play_sfx(SoundManager.CLICK)
	toggle()

func _on_toggle_button_mouse_entered() -> void:
	SoundManager.play_sfx(SoundManager.MOUSE_ENTERED)
