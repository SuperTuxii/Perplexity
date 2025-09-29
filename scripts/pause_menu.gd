class_name PauseMenu extends Control

@export
var drag_sensitivity: float = 0.005

func _on_visibility_changed() -> void:
	if is_inside_tree():
		get_tree().paused = visible
	$Layout/PanelContainer/MarginContainer/SensitivitySlider.set_value_no_signal((drag_sensitivity - 0.00005) * 10000)
	$Layout/PanelContainer2/MarginContainer/VolumeSlider.set_value_no_signal(AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("Master")))

func _on_continue_button_pressed() -> void:
	visible = false

func _on_sensitivity_slider_value_changed(value: float) -> void:
	drag_sensitivity = value / 10000 + 0.00005

func _on_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))
