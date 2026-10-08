extends Node2D

@onready var custom_button: Button = $CustomButton
@onready var team_1: Node2D = $Team_1
@onready var team_2: Node2D = $Team_2

func _ready() -> void:
	team_1.arena_team.load_team(GameManager.team)
	
	team_1.team_attacked.connect(func(dmg: Damage): team_2.take_damage(dmg))
	team_2.team_attacked.connect(func(dmg: Damage): team_1.take_damage(dmg))

	team_1.defeated.connect(func():
		print("Team 2 Won!")
		for slot in team_1.arena_team.slots:
			var u: Unit = slot.get_unit()
			if u:
				var context := AbilityContext.new(u, team_1.arena_team)
				u.trigger_abilities(Ability.Trigger.ON_DEFEAT, context)
	)
	
	team_2.defeated.connect(func():
		print("Team 1 Won!")
		for slot in team_1.arena_team.slots:
			var u: Unit = slot.get_unit()
			if u:
				var context := AbilityContext.new(u, team_1.arena_team)
				u.trigger_abilities(Ability.Trigger.ON_VICTORY, context)
	)
	
func _on_custom_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/places/shop.tscn")
