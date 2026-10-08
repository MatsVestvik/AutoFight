class_name Ability
extends Resource

enum Trigger {
	ON_BUY,
	ON_SELL,
	ON_TRIGGER,     # Cooldown timer attack in arena
	ON_VICTORY,
	ON_DEFEAT,
	ON_ROUND_START
}

enum Target {
	SELF,
	ALL_ALLIES,
	RANDOM_ALLY,
	ALLY_AHEAD,
	ALLY_BEHIND,
	PLAYER_GAME     # Modifies game state like coins
}

enum EffectType {
	BUFF_STAT,
	GAIN_COINS,
	DEAL_DAMAGE
}

enum StatType {
	ATTACK,
	POISON,
	SHIELD,
	BURN
}

@export var ability_name: String = ""
@export_multiline var description: String = ""
@export var trigger: Trigger = Trigger.ON_BUY
@export var target: Target = Target.SELF
@export var effect_type: EffectType = EffectType.BUFF_STAT

@export_group("Effect Details")
@export var stat_type: StatType = StatType.ATTACK
@export var value: int = 1

func can_trigger(trigger_type: Trigger) -> bool:
	return trigger == trigger_type

func execute(context: AbilityContext) -> void:
	match effect_type:
		EffectType.GAIN_COINS:

				GameManager.add_coins(value)

		EffectType.BUFF_STAT:
			var targets: Array[Unit] = _resolve_targets(context)
			for t in targets:
				t.apply_buff(stat_type, value)

		EffectType.DEAL_DAMAGE:
			pass

func _resolve_targets(context: AbilityContext) -> Array[Unit]:
	var result: Array[Unit] = []
	var team: Team = context.team
	var source: Unit = context.source_unit

	match target:
		Target.SELF:
			if is_instance_valid(source):
				result.append(source)

		Target.ALL_ALLIES:
			if team:
				for slot in team.slots:
					var u: Unit = slot.get_unit()
					if u != null:
						result.append(u)

		Target.RANDOM_ALLY:
			if team:
				var allies: Array[Unit] = []
				for slot in team.slots:
					var u: Unit = slot.get_unit()
					if u != null:
						allies.append(u)
				if allies.size() > 0:
					result.append(allies.pick_random())

		Target.ALLY_AHEAD:
			if team and source and source.current_slot:
				var idx = team.slots.find(source.current_slot)
				if idx > 0 and not team.slots[idx - 1].is_empty():
					result.append(team.slots[idx - 1].get_unit())

		Target.ALLY_BEHIND:
			if team and source and source.current_slot:
				var idx = team.slots.find(source.current_slot)
				if idx != -1 and idx < team.slots.size() - 1 and not team.slots[idx +
1].is_empty():
					result.append(team.slots[idx + 1].get_unit())

	return result
