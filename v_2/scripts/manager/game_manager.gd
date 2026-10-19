extends Node

const STARTING_COINS: int = 50
const STARTING_HEALTH: int = 10
const ROUND_COINS_REWARD: int = 10
const TARGET_WINS: int = 10
const ENEMY_DB_PATH: String = "res://resources/enemy_teams_db.json"

var units: Array[UnitData] = []
var team: Array[UnitData] = []
var enemy_teams_db: Dictionary = {}

var coins: int = STARTING_COINS:
	set(value):
		coins = maxi(0, value)
		stats_changed.emit()

var health: int = STARTING_HEALTH:
	set(value):
		health = maxi(0, value)
		stats_changed.emit()

var wins: int = 0:
	set(value):
		wins = maxi(0, value)
		stats_changed.emit()

var day: int = 1:
	set(value):
		day = maxi(1, value)
		stats_changed.emit()

signal unit_hovered(unit_data: UnitData)
signal unit_unhovered()
signal stats_changed()

func _ready() -> void:
	units = get_all_unit_data()
	_load_enemy_db()
	
func get_all_unit_data() -> Array[UnitData]:
	var unit_data_list: Array[UnitData] = []
	var dir_path := "res://resources/units/"
	
	for file in DirAccess.get_files_at(dir_path):
		# When exporting, Godot sometimes adds '.remap' to .tres files
		var clean_file := file.trim_suffix(".remap")
		
		if clean_file.ends_with(".tres") or clean_file.ends_with(".res"):
			var resource = load(dir_path.path_join(clean_file))
			if resource is UnitData and not unit_data_list.has(resource):
				unit_data_list.append(resource)

	return unit_data_list

func _load_enemy_db() -> void:
	if not FileAccess.file_exists(ENEMY_DB_PATH):
		enemy_teams_db = {}
		return
	var file := FileAccess.open(ENEMY_DB_PATH, FileAccess.READ)
	if file == null:
		enemy_teams_db = {}
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if parsed is Dictionary:
		enemy_teams_db = parsed
	else:
		enemy_teams_db = {}

func _save_enemy_db() -> void:
	var file := FileAccess.open(ENEMY_DB_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(enemy_teams_db, "\t"))

func save_team_for_day(target_day: int, team_data: Array[UnitData]) -> void:
	var has_unit: bool = false
	var serialized_team: Array = []

	for i in range(6):
		var u: UnitData = team_data[i] if i < team_data.size() else null
		if u != null:
			has_unit = true
			serialized_team.append({
				"name": u.name,
				"attack": u.attack,
				"poison": u.poison,
				"shield": u.shield,
				"burn": u.burn,
				"level": u.level
			})
		else:
			serialized_team.append(null)

	if not has_unit:
		return

	var day_key := str(target_day)
	if not enemy_teams_db.has(day_key) or not (enemy_teams_db[day_key] is Array):
		enemy_teams_db[day_key] = []

	var day_list: Array = enemy_teams_db[day_key]
	var serialized_json := JSON.stringify(serialized_team)
	for existing in day_list:
		if JSON.stringify(existing) == serialized_json:
			return

	day_list.append(serialized_team)
	_save_enemy_db()

func get_enemy_team_for_day(target_day: int) -> Array[UnitData]:
	var day_key := str(target_day)
	if enemy_teams_db.has(day_key) and enemy_teams_db[day_key] is Array:
		var exact_list: Array = enemy_teams_db[day_key]
		if exact_list.size() > 0:
			return _deserialize_team(exact_list.pick_random())

	# Fallback: find closest available day in database
	var closest_key: String = ""
	var closest_diff: int = INF
	for key in enemy_teams_db.keys():
		var list_val: Variant = enemy_teams_db[key]
		if list_val is Array and (list_val as Array).size() > 0:
			var d: int = int(str(key))
			var diff: int = absi(d - target_day)
			if diff < closest_diff:
				closest_diff = diff
				closest_key = str(key)

	if closest_key != "":
		var fallback_list: Array = enemy_teams_db[closest_key]
		return _deserialize_team(fallback_list.pick_random())

	# Final fallback: generate a random team if DB is completely empty
	return _generate_random_team(target_day)

func _deserialize_team(serialized_team: Array) -> Array[UnitData]:
	var result: Array[UnitData] = []
	for i in range(6):
		var entry: Variant = serialized_team[i] if i < serialized_team.size() else null
		if entry is Dictionary:
			var unit_name: String = str(entry.get("name", ""))
			var base_unit: UnitData = _find_unit_by_name(unit_name)
			if base_unit != null:
				var copy: UnitData = base_unit.duplicate()
				copy.attack = int(entry.get("attack", copy.attack))
				copy.poison = int(entry.get("poison", copy.poison))
				copy.shield = int(entry.get("shield", copy.shield))
				copy.burn = int(entry.get("burn", copy.burn))
				copy.level = int(entry.get("level", copy.level))
				result.append(copy)
			else:
				result.append(null)
		else:
			result.append(null)
	return result

func _find_unit_by_name(unit_name: String) -> UnitData:
	for u in units:
		if u.name.to_lower() == unit_name.to_lower():
			return u
	return null

func _generate_random_team(target_day: int) -> Array[UnitData]:
	var result: Array[UnitData] = [null, null, null, null, null, null]
	if units.is_empty():
		return result
	var count: int = clampi(target_day, 1, 6)
	for i in range(count):
		result[i] = units.pick_random().duplicate()
	return result

func add_coins(p_coins: int) -> void:
	coins += p_coins

func spend_coins(amount: int) -> bool:
	if coins < amount:
		return false
	coins -= amount
	return true

func on_battle_won() -> void:
	wins += 1
	if wins >= TARGET_WINS:
		reset_game()
	else:
		day += 1
		coins += ROUND_COINS_REWARD

func on_battle_lost() -> void:
	health -= 1
	if health <= 0:
		reset_game()
	else:
		day += 1
		coins += ROUND_COINS_REWARD

func reset_game() -> void:
	team.clear()
	coins = STARTING_COINS
	health = STARTING_HEALTH
	wins = 0
	day = 1
