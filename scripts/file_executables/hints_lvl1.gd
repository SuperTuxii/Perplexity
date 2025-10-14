class_name HintsLvl1 extends ScreenPopup

var data: Dictionary

var triangle_hints: Array = [
	"The digit is hidden in an image",
	"Someone reported a paper with something like this some time ago"
]
var circle_hints: Array = [
	"It's hidden in a text",
	"I might have lost something with a circle some time ago"
]
var square_hints: Array = [
	"It's hidden in a text",
	"There was a rumor about a man and something with a square"
]
var octagon_hints: Array = [
	"I wonder what this looks like",
	"The digit is hidden in an image",
	"It looks like a certain traffic sign"
]

func _on_triangle_button_pressed() -> void:
	$VBoxContainer/Content/TypeSelectionLayout.hide()
	var hint_number: int = data.get("triangle_number", 0)
	$VBoxContainer/Content/HintText.text = triangle_hints[hint_number % triangle_hints.size()]
	data["triangle_number"] = hint_number+1

func _on_circle_button_pressed() -> void:
	$VBoxContainer/Content/TypeSelectionLayout.hide()
	var hint_number: int = data.get("circle_number", 0)
	$VBoxContainer/Content/HintText.text = circle_hints[hint_number % circle_hints.size()]
	data["circle_number"] = hint_number+1

func _on_square_button_pressed() -> void:
	$VBoxContainer/Content/TypeSelectionLayout.hide()
	var hint_number: int = data.get("square_number", 0)
	$VBoxContainer/Content/HintText.text = square_hints[hint_number % square_hints.size()]
	data["square_number"] = hint_number+1

func _on_octagon_button_pressed() -> void:
	$VBoxContainer/Content/TypeSelectionLayout.hide()
	var hint_number: int = data.get("octagon_number", 0)
	$VBoxContainer/Content/HintText.text = octagon_hints[hint_number % octagon_hints.size()]
	data["octagon_number"] = hint_number+1
