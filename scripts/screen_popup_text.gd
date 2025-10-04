class_name ScreenPopupText extends ScreenPopup

@export_multiline
var text: String:
	set(value):
		$VBoxContainer/Content/Label.text = value
	get:
		return $VBoxContainer/Content/Label.text
