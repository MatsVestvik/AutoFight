extends Unit
class_name ArenaUnit

var current_timer: float
signal attacked(damage:Damage)

func _process(delta: float) -> void:
	current_timer += delta
	if data.cooldown_time <= 0:
		return
		
	if current_timer > data.cooldown_time:
		current_timer -= data.cooldown_time
		trigger()
	pass
	
func trigger() -> void:
	animation_player.play("attack")
	attacked.emit(Damage.new(data.attack, Damage.Type.NORMAL, self))
	await animation_player.animation_finished
	animation_player.play("idle")
