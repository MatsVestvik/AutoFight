extends Node2D
class_name SidePanel

const OPEN_TEXTURE = preload("uid://cra12nepuo5pc")
const CLOSE_TEXTURE = preload("uid://b4ohdvkt5wroe")
const PANEL_WIDTH: float = 164.0
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

@export var start_open: bool = false

@onready var toggle_button: TextureButton = $ToggleButton
@onready var margin_container: MarginContainer = $MarginContainer
@onready var grid_container: GridContainer = get_node_or_null("MarginContainer/GridContainer")

var is_open: bool = false
var closed_x: float = 288.0
var _tween: Tween

func _ready() -> void:
	closed_x = position.x
	is_open = start_open
	_populate_unit_overview()
	_update_panel(false)

func _populate_unit_overview() -> void:
	if grid_container:
		margin_container.remove_child(grid_container)
		grid_container.queue_free()

	var scroll := ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	margin_container.add_child(scroll)

	var vbox := VBoxContainer.new()
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.add_theme_constant_override("separation", 6)
	scroll.add_child(vbox)

	var title := Label.new()
	title.text = "UNIT PACK"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_override("font", FONT)
	title.add_theme_font_size_override("font_size", 16)
	title.add_theme_color_override("font_outline_color", Color.BLACK)
	title.add_theme_constant_override("outline_size", 3)
	vbox.add_child(title)

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
		header.add_theme_font_size_override("font_size", 12)
		header.add_theme_color_override("font_color", RARITY_COLORS.get(rarity, Color.WHITE))
		header.add_theme_color_override("font_outline_color", Color.BLACK)
		header.add_theme_constant_override("outline_size", 3)
		vbox.add_child(header)

		var tier_grid := GridContainer.new()
		tier_grid.columns = 2
		tier_grid.add_theme_constant_override("h_separation", 4)
		tier_grid.add_theme_constant_override("v_separation", 4)
		vbox.add_child(tier_grid)

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

func toggle() -> void:
	is_open = not is_open
	_update_panel(true)

func _update_panel(animate: bool) -> void:
	var target_x: float = (closed_x - PANEL_WIDTH) if is_open else closed_x
	toggle_button.texture_normal = CLOSE_TEXTURE if is_open else OPEN_TEXTURE

	if _tween and _tween.is_valid():
		_tween.kill()

	if animate:
		_tween = create_tween()
		_tween.tween_property(self, "position:x", target_x, 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	else:
		position.x = target_x

func _on_toggle_button_pressed() -> void:
	SoundManager.play_sfx(SoundManager.CLICK)
	toggle()

func _on_toggle_button_mouse_entered() -> void:
	SoundManager.play_sfx(SoundManager.MOUSE_ENTERED)
