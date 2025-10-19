class_name UnlockCode extends ScreenPopup

var correct_code: String
var data: Dictionary

func _ready() -> void:
	super._ready()
	if data.has("unlocked") and data["unlocked"]:
		$VBoxContainer/Content/VBoxContainer.visible = false
		$VBoxContainer/Content/AlreadyUnlockedLabel.visible = true
	else:
		$VBoxContainer/Content/VBoxContainer/CodeLineEdit.grab_focus()

func _on_code_line_edit_text_submitted(new_text: String) -> void:
	check_code(new_text)

func _on_unlock_button_pressed() -> void:
	check_code($VBoxContainer/Content/VBoxContainer/CodeLineEdit.text)

func check_code(code: String) -> void:
	if code.strip_edges() == correct_code:
		data["unlocked"] = true
		$VBoxContainer/Content/VBoxContainer.visible = false
		$VBoxContainer/Content/CorrectLabel.visible = true
		Audio.play("correct", Audio.correct, -10, "SFX", Audio.MONITOR_POSITION)
		EventBus.unlock_server.emit(path.substr(0, path.find("/")))
	else:
		Audio.play("wrong", Audio.wrong, -10, "SFX", Audio.MONITOR_POSITION)
