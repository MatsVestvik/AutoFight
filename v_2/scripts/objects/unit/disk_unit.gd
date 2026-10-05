extends Unit
class_name DiskUnit

signal buy(data:UnitData, disk_unit:DiskUnit)

func _on_pressed() -> void:
	buy.emit(data, self)
