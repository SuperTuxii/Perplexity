class_name ScreenPopup extends PanelContainer

signal closed

@export
var title: String:
	set(value):
		$VBoxContainer/Top/TitleLabel.text = value
	get:
		return $VBoxContainer/Top/TitleLabel.text

var mouse_pressed: bool = false

func _on_title_label_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		mouse_pressed = event.pressed
	elif event is InputEventMouseMotion and mouse_pressed:
		position += event.relative

func _on_close_button_pressed() -> void:
	visible = false
	closed.emit()
