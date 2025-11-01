class_name ScreenPopupTextEdit extends ScreenPopup

signal using_scroll
signal not_using_scroll

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


func _on_text_edit_mouse_entered() -> void:
	using_scroll.emit()
func _on_text_edit_mouse_exited() -> void:
	not_using_scroll.emit()
