extends PanelContainer
class_name UnitPackView

const CLOSE = preload("res://assets/icons/close.png")
const HOVER_CLOSE = preload("res://assets/icons/hover_close.png")
const DISK_UNIT = preload("uid://bu8jiidw7frlw")
const FONT = preload("uid://c2h8gscc2qba0")

const RARITY_ORDER: Array[int] = [
	UnitData.RARITY.COMMON,
	UnitData.RARITY.UNCOMMON,
	UnitData.RARITY.RARE,
	UnitData.RARITY.EPIC,
	UnitData.RARITY.LEGENDARY,
	UnitData.RARITY.MYTHICAL
]

const RARITY_NAMES: Dictionary = {
	UnitData.RARITY.COMMON: "COMMON",
	UnitData.RARITY.UNCOMMON: "UNCOMMON",
	UnitData.RARITY.RARE: "RARE",
	UnitData.RARITY.EPIC: "EPIC",
	UnitData.RARITY.LEGENDARY: "LEGENDARY",
	UnitData.RARITY.MYTHICAL: "MYTHICAL"
}

const RARITY_COLORS: Dictionary = {
	UnitData.RARITY.COMMON: Color(0.8, 0.8, 0.8, 1.0),
	UnitData.RARITY.UNCOMMON: Color(0.2, 0.85, 0.2, 1.0),
	UnitData.RARITY.RARE: Color(0.3, 0.6, 1.0, 1.0),
	UnitData.RARITY.EPIC: Color(0.7, 0.3, 1.0, 1.0),
	UnitData.RARITY.LEGENDARY: Color(1.0, 0.65, 0.1, 1.0),
	UnitData.RARITY.MYTHICAL: Color(1.0, 0.25, 0.5, 1.0)
}

@onready var close_button: Button = $Window/CloseButton
@onready var content_vbox: VBoxContainer = $MarginContainer/VBoxContainer/ScrollContainer/ContentVBox

func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)
	_populate_unit_overview()

func _populate_unit_overview() -> void:
	for child in content_vbox.get_children():
		content_vbox.remove_child(child)
		child.queue_free()

	var all_units: Array[UnitData] = GameManager.units
	if all_units.is_empty():
		all_units = GameManager.get_all_unit_data()

	for rarity in RARITY_ORDER:
		var tier_units: Array[UnitData] = []
		for u in all_units:
			if u and u.rarity == rarity:
				tier_units.append(u)
		if tier_units.is_empty():
			continue

		tier_units.sort_custom(func(a: UnitData, b: UnitData) -> bool:
			return a.name.naturalnocasecmp_to(b.name) < 0
		)

		var header := Label.new()
		header.text = RARITY_NAMES.get(rarity, "TIER")
		header.add_theme_font_override("font", FONT)
		header.add_theme_font_size_override("font_size", 14)
		header.add_theme_color_override("font_color", RARITY_COLORS.get(rarity, Color.WHITE))
		header.add_theme_color_override("font_outline_color", Color.BLACK)
		header.add_theme_constant_override("outline_size", 3)
		content_vbox.add_child(header)

		var tier_grid := GridContainer.new()
		tier_grid.columns = 4
		tier_grid.add_theme_constant_override("h_separation", 6)
		tier_grid.add_theme_constant_override("v_separation", 6)
		content_vbox.add_child(tier_grid)

		for u_data in tier_units:
			var card := _create_unit_preview_card(u_data)
			tier_grid.add_child(card)

func _create_unit_preview_card(u_data: UnitData) -> Control:
	var wrapper := Control.new()
	wrapper.custom_minimum_size = Vector2(56, 56)
	wrapper.mouse_filter = Control.MOUSE_FILTER_PASS

	var preview: DiskUnit = DISK_UNIT.instantiate()
	preview.position = Vector2(0, 0)
	preview.scale = Vector2(0.85, 0.85)
	wrapper.add_child(preview)
	preview.create_from_data(u_data)

	preview.mouse_entered.connect(func() -> void:
		SoundManager.play_sfx(SoundManager.MOUSE_ENTERED)
		GameManager.unit_hovered.emit(u_data)
	)
	preview.mouse_exited.connect(func() -> void:
		GameManager.unit_unhovered.emit()
	)
	return wrapper

func _on_visibility_changed() -> void:
	if not visible:
		GameManager.unit_unhovered.emit()

func _on_close_button_pressed() -> void:
	SoundManager.play_sfx(SoundManager.CLICK)
	hide()

func _on_close_button_mouse_entered() -> void:
	SoundManager.play_sfx(SoundManager.MOUSE_ENTERED)
	close_button.icon = HOVER_CLOSE

func _on_close_button_mouse_exited() -> void:
	close_button.icon = CLOSE
