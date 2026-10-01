extends Trophys

func _ready() -> void:
	set_trophys(GameManager.trophys)
	await get_tree().create_timer(1.0).timeout
	GameManager.trophys += 1
	set_trophys(GameManager.trophys)
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://scenes/shop.tscn")
