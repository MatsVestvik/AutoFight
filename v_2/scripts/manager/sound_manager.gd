extends Node

# Preload your sound streams (add your own audio files here)
#attack, buff, victory
const BUY = preload("uid://cclic6g10u4px")
const CLICK = preload("uid://ijunaw4tnig")
const ERROR = preload("uid://drafje5yas4ix")
const LEVEL_UP = preload("uid://c6xh4hpv66mtl")
const MOUSE_ENTERED = preload("uid://1bg6n7exwou6")
const SOLD = preload("uid://nq7bngm4r1ty")

## Plays a sound effect globally with optional pitch variation
func play_sfx(stream: AudioStream, pitch_variance: float = 0.1) -> void:
	if stream == null:
		return

	var player := AudioStreamPlayer.new()
	player.stream = stream
	player.bus = "SFX"

	if pitch_variance > 0.0:
		player.pitch_scale = randf_range(1.0 - pitch_variance, 1.0 + pitch_variance)

	add_child(player)
	player.play()

	# Automatically free the player node once the sound finishes playing
	player.finished.connect(player.queue_free)
