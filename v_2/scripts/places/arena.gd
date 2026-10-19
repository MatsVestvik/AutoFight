extends Node2D

@onready var custom_button: Button = $CustomButton
@onready var team_1: Node2D = $Team_1
@onready var team_2: Node2D = $Team_2

var battle_ended: bool = false

func _ready() -> void:
	team_1.arena_team.load_team(GameManager.team)
	var enemy_team: Array[UnitData] = GameManager.get_enemy_team_for_day(GameManager.day)
	team_2.arena_team.load_team(enemy_team)
	GameManager.save_team_for_day(GameManager.day, GameManager.team)
	
	team_1.team_attacked.connect(func(dmg: Damage): team_2.take_damage(dmg))
	team_2.team_attacked.connect(func(dmg: Damage): team_1.take_damage(dmg))

	team_1.defeated.connect(_on_team_1_defeated)
	team_2.defeated.connect(_on_team_2_defeated)

func _on_team_1_defeated() -> void:
	if battle_ended:
		return
	battle_ended = true
	print("Team 2 Won!")
	for slot in team_1.arena_team.slots:
		var u: Unit = slot.get_unit()
		if u:
			var context := AbilityContext.new(u, team_1.arena_team)
			u.trigger_abilities(Ability.Trigger.ON_DEFEAT, context)
	GameManager.team = team_1.arena_team.get_team_data()
	GameManager.on_battle_lost()
	get_tree().change_scene_to_file("res://scenes/places/shop.tscn")

func _on_team_2_defeated() -> void:
	if battle_ended:
		return
	battle_ended = true
	print("Team 1 Won!")
	for slot in team_1.arena_team.slots:
		var u: Unit = slot.get_unit()
		if u:
			var context := AbilityContext.new(u, team_1.arena_team)
			u.trigger_abilities(Ability.Trigger.ON_VICTORY, context)
	GameManager.team = team_1.arena_team.get_team_data()
	GameManager.on_battle_won()
	get_tree().change_scene_to_file("res://scenes/places/shop.tscn")
	
func _on_custom_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/places/shop.tscn")

