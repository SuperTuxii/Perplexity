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

func _on_unlock_button_pressed() -> void:
	if false: #TODO: Unlock Condition
		Audio.play("correct", Audio.correct, -10, "SFX", Audio.MONITOR_POSITION)
	else:
		Audio.play("wrong", Audio.wrong, -10, "SFX", Audio.MONITOR_POSITION)
