class_name HintsLvl1 extends ScreenPopup

@onready
var hint_label: RichTextLabel = $VBoxContainer/Content/HintContainer/HintText
@onready
var hint_container: VBoxContainer = $VBoxContainer/Content/HintContainer
@onready
var type_selection_layout: HBoxContainer = $VBoxContainer/Content/TypeSelectionLayout

var data: Dictionary
var type: int

func _on_triangle_button_pressed() -> void:
	type_selection_layout.hide()
	var hint_number: int = data.get("triangle_number", 0)
	hint_label.text = Config.level1_hints.triangle_hints[hint_number % Config.level1_hints.triangle_hints.size()]
	hint_container.show()
	data["triangle_number"] = hint_number+1
	type = 0

func _on_circle_button_pressed() -> void:
	type_selection_layout.hide()
	var hint_number: int = data.get("circle_number", 0)
	hint_label.text = Config.level1_hints.circle_hints[hint_number % Config.level1_hints.circle_hints.size()]
	hint_container.show()
	data["circle_number"] = hint_number+1
	type = 1

func _on_square_button_pressed() -> void:
	type_selection_layout.hide()
	var hint_number: int = data.get("square_number", 0)
	hint_label.text = Config.level1_hints.square_hints[hint_number % Config.level1_hints.square_hints.size()]
	hint_container.show()
	data["square_number"] = hint_number+1
	type = 2

func _on_octagon_button_pressed() -> void:
	type_selection_layout.hide()
	var hint_number: int = data.get("octagon_number", 0)
	hint_label.text = Config.level1_hints.octagon_hints[hint_number % Config.level1_hints.octagon_hints.size()]
	hint_container.show()
	data["octagon_number"] = hint_number+1
	type = 3

func _on_next_button_pressed() -> void:
	if type == 0:
		var hint_number: int = data.get("triangle_number", 0)
		hint_label.text = Config.level1_hints.triangle_hints[hint_number % Config.level1_hints.triangle_hints.size()]
		data["triangle_number"] = hint_number+1
	elif type == 1:
		var hint_number: int = data.get("circle_number", 0)
		hint_label.text = Config.level1_hints.circle_hints[hint_number % Config.level1_hints.circle_hints.size()]
		data["circle_number"] = hint_number+1
	elif type == 2:
		var hint_number: int = data.get("square_number", 0)
		hint_label.text = Config.level1_hints.square_hints[hint_number % Config.level1_hints.square_hints.size()]
		data["square_number"] = hint_number+1
	elif type == 3:
		var hint_number: int = data.get("octagon_number", 0)
		hint_label.text = Config.level1_hints.octagon_hints[hint_number % Config.level1_hints.octagon_hints.size()]
		data["octagon_number"] = hint_number+1
