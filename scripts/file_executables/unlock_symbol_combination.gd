class_name UnlockSymbolCombination extends ScreenPopup

@onready
var symbols: Control = $VBoxContainer/Content/Symbols

# Possible Shapes: circle, hexagon, octagon, square, star, triangle
var current_shapes: PackedStringArray:
	get:
		return data["current_shapes"]
# Possible Colors: RED, YELLOW, BLUE, CYAN, GREEN, ORANGE, MAGENTA, INDIGO(, CRIMSON)
var current_colors: PackedColorArray:
	get:
		return data["current_colors"]
var correct_shapes: PackedStringArray
var correct_colors: PackedColorArray
var data: Dictionary

func _ready() -> void:
	super._ready()
	if data.has("unlocked") and data["unlocked"]:
		$VBoxContainer/Content/UnlockButton.visible = false
		$VBoxContainer/Content/Line2D.visible = false
		$VBoxContainer/Content/Symbols.visible = false
		$VBoxContainer/Content/AlreadyUnlockedLabel.visible = true
	else:
		update_symbols()
		EventBus.updated_lvl2_unlock.connect(update_symbols)

func update_symbols() -> void:
	for i in range(symbols.get_child_count()):
		var symbol_button: Button = symbols.get_child(i)
		symbol_button.icon = load("res://assets/textures/shapes/" + current_shapes[i] + ".svg")
		symbol_button.add_theme_color_override("icon_disabled_color", apply_color_shader(current_colors[i]))

func set_symbol(symbol_index: int, symbol_shape: String, symbol_color: Color) -> void:
	var symbol_button: Button = symbols.get_child(symbol_index)
	current_shapes[symbol_index] = symbol_shape
	symbol_button.icon = load("res://assets/textures/shapes/" + symbol_shape + ".svg")
	current_colors[symbol_index] = symbol_color
	symbol_button.add_theme_color_override("icon_disabled_color", apply_color_shader(symbol_color))

func set_symbol_shape(symbol_index: int, symbol_shape: String) -> void:
	var symbol_button: Button = symbols.get_child(symbol_index)
	current_shapes[symbol_index] = symbol_shape
	symbol_button.icon = load("res://assets/textures/shapes/" + symbol_shape + ".svg")

func set_color(symbol_index: int, symbol_color: Color) -> void:
	var symbol_button: Button = symbols.get_child(symbol_index)
	current_colors[symbol_index] = symbol_color
	symbol_button.add_theme_color_override("icon_disabled_color", apply_color_shader(symbol_color))

static func apply_color_shader(color: Color) -> Color:
	color.s = 0.34
	color.v = 0.15
	color.a = 1
	return color

static func apply_action(file_data: Dictionary, symbol_index: int, action: Dictionary) -> void:
	if action.has("from_color") and file_data["current_colors"][symbol_index] != action.from_color:
		return
	if action.has("from_shape") and file_data["current_shapes"][symbol_index] != action.from_shape:
		return
	if action.has("to_color"):
		file_data["current_colors"][symbol_index] = action.to_color
	if action.has("to_shape"):
		file_data["current_shapes"][symbol_index] = action.to_shape

func _on_unlock_button_pressed() -> void:
	for i in range(current_shapes.size()):
		if current_shapes[i] != correct_shapes[i] or current_colors[i] != correct_colors[i]:
			Audio.play("wrong", Audio.wrong, -30, "SFX", Audio.MONITOR_POSITION)
			LEDControl.trigger_animation("flash", false, {"color": [200, 0, 0], "duration": 20})
			return
	data["unlocked"] = true
	$VBoxContainer/Content/UnlockButton.visible = false
	$VBoxContainer/Content/Line2D.visible = false
	$VBoxContainer/Content/Symbols.visible = false
	$VBoxContainer/Content/CorrectLabel.visible = true
	Audio.play("correct", Audio.correct, -35, "SFX", Audio.MONITOR_POSITION)
	LEDControl.trigger_animation("flash", false, {"color": [0, 200, 0], "duration": 20})
	EventBus.unlock_server.emit(path.substr(0, path.find("/")))
