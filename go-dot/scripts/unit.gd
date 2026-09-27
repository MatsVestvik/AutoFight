extends Node2D
class_name Unit

@onready var attack_label: Label = $attack
@onready var cooldown_label: Label = $cooldown
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var cooldownbar: ProgressBar = $cooldownbar

var attack: int;
var cooldown: float;
var current_timer: float = 0.0
var unit_name: String;

func _ready() -> void:
	return
	
func flip() -> void:
	sprite_2d.flip_h = !sprite_2d.flip_h;
	cooldownbar.position.x = -cooldownbar.position.x
	attack_label.position.x = -attack_label.position.x
	
func setup(data:unitData) -> void:
	sprite_2d.texture = data.sprite;
	attack_label.text = str(data.attack);
	cooldown_label.text = str(data.cooldown_speed);
	
	attack = data.attack
	cooldown = data.cooldown_speed
	cooldownbar.min_value = 0.0
	cooldownbar.max_value = data.cooldown_speed
	unit_name = data.unit_name
	
func _process(delta:float) -> void:
	if cooldown <= 0.0:
		print(unit_name, " no cooldown speed")
		return
	
	current_timer += delta
	cooldownbar.value = current_timer
	
	if current_timer >=  cooldown:
		current_timer -= cooldown
		cooldownbar.value = current_timer
		trigger()

signal attack_signal (amount: int, color_name: String)

func trigger() -> void:
	attack_signal.emit(attack, "red")
	print(unit_name, " attacked")
	
