extends Node

# Preload your sound streams (add your own audio files here)
#attack, buff, victory
const BUY = preload("uid://cclic6g10u4px")
const CLICK = preload("uid://ijunaw4tnig")
const ERROR = preload("uid://drafje5yas4ix")
const LEVEL_UP = preload("uid://c6xh4hpv66mtl")
const MOUSE_ENTERED = preload("uid://1bg6n7exwou6")
const SOLD = preload("uid://nq7bngm4r1ty")
const BUFF = preload("uid://bl4jhnloqqmx5")
const SELECT = preload("uid://0l0cdidqlhoa")
const BGM = preload("res://assets/audio/music/miromaxmusic-stylish-funk-smooth-party-no-copyright-620664.mp3")

const SFX_BUS := "SFX"
const MUSIC_BUS := "Music"

var sfx_volume: float = 1.0
var music_volume: float = 1.0
var music_player: AudioStreamPlayer

func _ready() -> void:
	_ensure_audio_buses()
	set_sfx_volume(sfx_volume)
	set_music_volume(music_volume)
	play_music(BGM)

func _ensure_audio_buses() -> void:
	if AudioServer.get_bus_index(SFX_BUS) == -1:
		var idx := AudioServer.bus_count
		AudioServer.add_bus(idx)
		AudioServer.set_bus_name(idx, SFX_BUS)
		AudioServer.set_bus_send(idx, "Master")
	if AudioServer.get_bus_index(MUSIC_BUS) == -1:
		var idx := AudioServer.bus_count
		AudioServer.add_bus(idx)
		AudioServer.set_bus_name(idx, MUSIC_BUS)
		AudioServer.set_bus_send(idx, "Master")

func play_music(stream: AudioStream) -> void:
	if stream == null:
		return
	if music_player == null:
		music_player = AudioStreamPlayer.new()
		music_player.bus = MUSIC_BUS
		music_player.finished.connect(_on_music_finished)
		add_child(music_player)
	if music_player.stream != stream or not music_player.playing:
		music_player.stream = stream
		music_player.play()

func _on_music_finished() -> void:
	if music_player:
		music_player.play()

func set_sfx_volume(linear_val: float) -> void:
	sfx_volume = clampf(linear_val, 0.0, 1.0)
	_apply_bus_volume(SFX_BUS, sfx_volume)

func set_music_volume(linear_val: float) -> void:
	music_volume = clampf(linear_val, 0.0, 1.0)
	_apply_bus_volume(MUSIC_BUS, music_volume)

func _apply_bus_volume(bus_name: String, linear_val: float) -> void:
	var bus_idx := AudioServer.get_bus_index(bus_name)
	if bus_idx == -1:
		return
	if linear_val <= 0.001:
		AudioServer.set_bus_mute(bus_idx, true)
	else:
		AudioServer.set_bus_mute(bus_idx, false)
		AudioServer.set_bus_volume_db(bus_idx, linear_to_db(linear_val))

## Plays a sound effect globally with optional pitch variation
func play_sfx(stream: AudioStream, pitch_variance: float = 0.1) -> void:
	if stream == null:
		return

	var player := AudioStreamPlayer.new()
	player.stream = stream
	player.bus = SFX_BUS

	if pitch_variance > 0.0:
		player.pitch_scale = randf_range(1.0 - pitch_variance, 1.0 + pitch_variance)

	add_child(player)
	player.play()

	# Automatically free the player node once the sound finishes playing
	player.finished.connect(player.queue_free)
