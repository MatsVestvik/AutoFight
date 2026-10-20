extends Node2D

const SPEED_1 = preload("res://assets/util/1_speed.png")
const SPEED_2 = preload("res://assets/util/2_speed.png")
const SPEED_3 = preload("res://assets/util/3_speed.png")

@onready var custom_button: Button = $CustomButton
@onready var speed_button: Button = $SpeedButton
@onready var team_1: Node2D = $Team_1
@onready var team_2: Node2D = $Team_2

var battle_ended: bool = false
var current_speed: int = 1

func _ready() -> void:
	Engine.time_scale = 1.0
	_update_speed_icon()
	team_1.arena_team.load_team(GameManager.team)
	var enemy_team: Array[UnitData] = GameManager.get_enemy_team_for_day(GameManager.day)
	team_2.arena_team.load_team(enemy_team)
	GameManager.save_team_for_day(GameManager.day, GameManager.team)
	
	team_1.team_attacked.connect(func(dmg: Damage): team_2.take_damage(dmg))
	team_2.team_attacked.connect(func(dmg: Damage): team_1.take_damage(dmg))

	team_1.defeated.connect(_on_team_1_defeated)
	team_2.defeated.connect(_on_team_2_defeated)

func _exit_tree() -> void:
	Engine.time_scale = 1.0

func _on_speed_button_pressed() -> void:
	SoundManager.play_sfx(SoundManager.CLICK)
	current_speed = (current_speed % 3) + 1
	Engine.time_scale = float(current_speed)
	_update_speed_icon()

func _update_speed_icon() -> void:
	match current_speed:
		1:
			speed_button.icon = SPEED_1
		2:
			speed_button.icon = SPEED_2
		3:
			speed_button.icon = SPEED_3

func _on_team_1_defeated() -> void:
	if battle_ended:
		return
	battle_ended = true
	Engine.time_scale = 1.0
	print("Team 2 Won!")
	for slot in team_1.arena_team.slots:
		var u: Unit = slot.get_unit()
		if u:
			var context := AbilityContext.new(u, team_1.arena_team)
			u.trigger_abilities(Ability.Trigger.ON_DEFEAT, context)
	GameManager.team = team_1.arena_team.get_team_data()
	get_tree().change_scene_to_file("res://scenes/places/lose_health.tscn")

func _on_team_2_defeated() -> void:
	if battle_ended:
		return
	battle_ended = true
	Engine.time_scale = 1.0
	print("Team 1 Won!")
	for slot in team_1.arena_team.slots:
		var u: Unit = slot.get_unit()
		if u:
			var context := AbilityContext.new(u, team_1.arena_team)
			u.trigger_abilities(Ability.Trigger.ON_VICTORY, context)
	GameManager.team = team_1.arena_team.get_team_data()
	get_tree().change_scene_to_file("res://scenes/places/gain_trophy.tscn")
	
func _on_custom_button_pressed() -> void:
	Engine.time_scale = 1.0
	get_tree().change_scene_to_file("res://scenes/places/shop.tscn")
