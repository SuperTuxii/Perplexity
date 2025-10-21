class_name HintsLvl2 extends ScreenPopup

@onready
var hint_label: RichTextLabel = $VBoxContainer/Content/HintContainer/HintText
@onready
var hint_container: VBoxContainer = $VBoxContainer/Content/HintContainer
@onready
var type_selection_layout: HBoxContainer = $VBoxContainer/Content/TypeSelectionLayout

var data: Dictionary
var type: int = 0

func _on_shape_button_pressed() -> void:
	type_selection_layout.hide()
	var hint_number: int = data.get("shape_number", 0)
	hint_label.text = Config.level2_hints.shape_hints[hint_number % Config.level2_hints.shape_hints.size()]
	hint_container.show()
	data["shape_number"] = hint_number+1
	type = 0

func _on_color_button_pressed() -> void:
	type_selection_layout.hide()
	var hint_number: int = data.get("color_number", 0)
	hint_label.text = Config.level2_hints.color_hints[hint_number % Config.level2_hints.color_hints.size()]
	hint_container.show()
	data["color_number"] = hint_number+1
	type = 1

func _on_next_button_pressed() -> void:
	if type == 0:
		var hint_number: int = data.get("shape_number", 0)
		hint_label.text = Config.level2_hints.shape_hints[hint_number % Config.level2_hints.shape_hints.size()]
		data["shape_number"] = hint_number+1
	else:
		var hint_number: int = data.get("color_number", 0)
		hint_label.text = Config.level2_hints.color_hints[hint_number % Config.level2_hints.color_hints.size()]
		data["color_number"] = hint_number+1
