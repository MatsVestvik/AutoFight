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
	var parent_team: Team = current_slot.get_parent() as Team if current_slot else null
	var context := AbilityContext.new(self, parent_team)
	trigger_abilities(Ability.Trigger.ON_TRIGGER, context)
	animation_player.play("attack")
	attacked.emit(Damage.new(data.attack, Damage.Type.NORMAL, self))
	attacked.emit(Damage.new(data.poison, Damage.Type.POISON, self))
	attacked.emit(Damage.new(data.shield, Damage.Type.SHIELD, self))
	attacked.emit(Damage.new(data.burn, Damage.Type.BURN, self))
	await animation_player.animation_finished
	animation_player.play("idle")
