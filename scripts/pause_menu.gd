class_name PauseMenu extends Control

@export
var drag_sensitivity: float = 0.005

func _on_continue_button_pressed() -> void:
	self.visible = false

func _on_sensitivity_slider_value_changed(value: float) -> void:
	drag_sensitivity = value / 1000
