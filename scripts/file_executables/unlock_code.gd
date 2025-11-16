class_name UnlockCode extends ScreenPopup

@onready
var code_line_edit: LineEdit = $VBoxContainer/Content/VBoxContainer/CodeLineEdit

var correct_code: String
var data: Dictionary

func _ready() -> void:
	super._ready()
	if data.has("unlocked") and data["unlocked"]:
		$VBoxContainer/Content/VBoxContainer.visible = false
		$VBoxContainer/Content/AlreadyUnlockedLabel.visible = true
	else:
		code_line_edit.grab_focus()
	code_line_edit.max_length = correct_code.length()

func _on_code_line_edit_text_submitted(new_text: String) -> void:
	check_code(new_text)

func _on_unlock_button_pressed() -> void:
	check_code(code_line_edit.text)

func check_code(code: String) -> void:
	if code.strip_edges() == correct_code:
		data["unlocked"] = true
		$VBoxContainer/Content/VBoxContainer.visible = false
		$VBoxContainer/Content/CorrectLabel.visible = true
		Audio.play("correct", Audio.correct, -35, "SFX", Audio.MONITOR_POSITION)
		LEDControl.trigger_animation("flash", false, {"color": [0, 200, 0], "duration": 20})
		EventBus.unlock_server.emit(path.substr(0, path.find("/")))
	else:
		Audio.play("wrong", Audio.wrong, -30, "SFX", Audio.MONITOR_POSITION)
		LEDControl.trigger_animation("flash", false, {"color": [200, 0, 0], "duration": 20})

func set_number(number: String) -> void:
	code_line_edit.text += number

func _on_button_pressed() -> void:
	set_number("1")
func _on_button_2_pressed() -> void:
	set_number("2")
func _on_button_3_pressed() -> void:
	set_number("3")
func _on_button_4_pressed() -> void:
	set_number("4")
func _on_button_5_pressed() -> void:
	set_number("5")
func _on_button_6_pressed() -> void:
	set_number("6")
func _on_button_7_pressed() -> void:
	set_number("7")
func _on_button_8_pressed() -> void:
	set_number("8")
func _on_button_9_pressed() -> void:
	set_number("9")
func _on_button_10_pressed() -> void:
	set_number("0")
func _on_button_11_pressed() -> void:
	code_line_edit.text = code_line_edit.text.left(-1)
