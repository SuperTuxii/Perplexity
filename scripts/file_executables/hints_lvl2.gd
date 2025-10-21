class_name HintsLvl2 extends ScreenPopup

var data: Dictionary

var shape_hints: Array = [
	"the requests folder may contain some information",
	"try searching for related telephone numbers and observe what happens in the unlock executable when calling them"
]
var color_hints: Array = [
	"the staff folder may contain some information",
	"try searching for related telephone numbers and observe what happens in the unlock executable when calling them"
]

func _on_shape_button_pressed() -> void:
	$VBoxContainer/Content/TypeSelectionLayout.hide()
	var hint_number: int = data.get("shape_number", 0)
	$VBoxContainer/Content/HintText.text = shape_hints[hint_number % shape_hints.size()]
	data["shape_number"] = hint_number+1

func _on_color_button_pressed() -> void:
	$VBoxContainer/Content/TypeSelectionLayout.hide()
	var hint_number: int = data.get("color_number", 0)
	$VBoxContainer/Content/HintText.text = color_hints[hint_number % color_hints.size()]
	data["color_number"] = hint_number+1
