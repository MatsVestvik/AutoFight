extends superUnit
class_name Unit

@onready var cooldownbar: ProgressBar = $cooldownbar

func _ready() -> void:
	return
	
func flip() -> void:
	if sprite_2d:
		sprite_2d.flip_h = not sprite_2d.flip_h
	
	
func setup(data:unitData) -> void:
	unit_data = data.duplicate()
	sprite_2d.texture = data.sprite;
	attack_label.text = str(data.attack);
	
	cooldownbar.min_value = 0.0
	cooldownbar.max_value = data.cooldown_speed
	
func update() -> void:
	attack_label.text = str(self.unit_data.attack)
	
func _process(delta:float) -> void:
	if unit_data.cooldown_speed <= 0.0:
		print(unit_data.unit_name, " no cooldown speed")
		return
	
	current_timer += delta
	cooldownbar.value = current_timer
	
	if current_timer >=  unit_data.cooldown_speed:
		current_timer -= unit_data.cooldown_speed
		cooldownbar.value = current_timer
		trigger()

func trigger() -> void:
	self.unit_data.attack += 1
	update()
	trigger_signal.emit(self)
	print(unit_data.unit_name, " attacked")
	
