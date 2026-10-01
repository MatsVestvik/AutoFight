extends Hearts

func _ready() -> void:
	set_hearts(GameManager.hearts)
	await get_tree().create_timer(1.0).timeout
	GameManager.hearts -= 1
	set_hearts(GameManager.hearts)
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://scenes/shop.tscn")
