class_name ScreenPopupTextEdit extends ScreenPopup

@export_multiline
var text: String:
	set(value):
		$VBoxContainer/Content/TextEdit.text = value
	get:
		return $VBoxContainer/Content/TextEdit.text

var data: Dictionary

func _on_text_edit_text_changed() -> void:
	data["value"] = text
	data["size"] = text.length() * 2
