class_name UnlockSymbolCombination extends ScreenPopup

@onready
var symbols: Control = $VBoxContainer/Content/Symbols

var correct_shapes: PackedStringArray
var correct_colors: PackedColorArray
var data: Dictionary

func set_symbol(symbol_index: int, symbol_shape: String, symbol_color: Color) -> void:
	var symbol_button: Button = symbols.get_child(symbol_index)
	symbol_button.icon = load("res://assets/textures/shapes/" + symbol_shape + ".svg")
	symbol_button.add_theme_color_override("icon_disabled_color", apply_color_shader(symbol_color))

func set_symbol_shape(symbol_index: int, symbol_shape: String) -> void:
	var symbol_button: Button = symbols.get_child(symbol_index)
	symbol_button.icon = load("res://assets/textures/shapes/" + symbol_shape + ".svg")

func set_color(symbol_index: int, symbol_color: Color) -> void:
	var symbol_button: Button = symbols.get_child(symbol_index)
	symbol_button.add_theme_color_override("icon_disabled_color", apply_color_shader(symbol_color))

func apply_color_shader(color: Color) -> Color:
	color.s = 0.34
	color.v = 0.15
	color.a = 1
	return color
