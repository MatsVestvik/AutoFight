extends PanelContainer

const CLOSE = preload("res://assets/icons/close.png")
const HOVER_CLOSE = preload("res://assets/icons/hover_close.png")

@onready var close_button: Button = $Window/CloseButton
@onready var music_slider: HSlider = $MarginContainer/VBoxContainer/MusicBox/MusicSlider
@onready var sfx_slider: HSlider = $MarginContainer/VBoxContainer/FXBox/SFXSlider

func _ready() -> void:
	music_slider.value = SoundManager.music_volume
	sfx_slider.value = SoundManager.sfx_volume

func _on_music_slider_value_changed(value: float) -> void:
	SoundManager.set_music_volume(value)

func _on_sfx_slider_value_changed(value: float) -> void:
	SoundManager.set_sfx_volume(value)

func _on_quit_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/places/start_screen.tscn")


func _on_close_button_pressed() -> void:
	hide()


func _on_close_button_mouse_entered() -> void:
	close_button.icon = HOVER_CLOSE


func _on_close_button_mouse_exited() -> void:
	close_button.icon = CLOSE
