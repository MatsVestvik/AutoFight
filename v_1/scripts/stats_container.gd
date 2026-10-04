extends Node2D

const SINGLE_CONTAINER = preload("uid://bhxb5q44dnl5u")
@onready var h_box: HBoxContainer = $HBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_from_unit_data(GameManager.ARCHER_DATA)
	
func create_from_unit_data(data: unitData) -> void:
	for child in h_box.get_children():
		child.queue_free()
		
	if data.attack != 0:
		var container: Control = SINGLE_CONTAINER.instantiate()
		h_box.add_child(container)
		container.set_color("NORMAL")
		container.set_info(data.attack)
		
	if data.poison != 0:
		var container: Control = SINGLE_CONTAINER.instantiate()
		h_box.add_child(container)
		container.set_color("POISON")
		container.set_info(data.poison)
		
	if data.burn != 0:
		var container: Control = SINGLE_CONTAINER.instantiate()
		h_box.add_child(container)
		container.set_color("FIRE")
		container.set_info(data.burn)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
