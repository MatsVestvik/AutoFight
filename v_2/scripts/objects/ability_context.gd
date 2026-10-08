class_name AbilityContext
extends RefCounted

var source_unit: Unit
var team: Team
var enemy_team: Team
var extra_data: Dictionary = {}

func _init(p_source: Unit, p_team: Team = null, p_enemy: Team = null, p_extra: Dictionary =
{}) -> void:
	source_unit = p_source
	team = p_team
	enemy_team = p_enemy
	extra_data = p_extra
