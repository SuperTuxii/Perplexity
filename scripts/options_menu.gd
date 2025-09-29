class_name OptionsMenu extends PanelContainer

signal back

@export
var drag_sensitivity: float = 0.005
@export
var drag_mirrored: bool = false
@export
var volume: float = 1.0

func _ready() -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(volume))

func _on_visibility_changed() -> void:
	$Layout/ScrollContainer/TableLayout/SensitivitySlider.set_value_no_signal((drag_sensitivity - 0.00005) * 10000)
	$Layout/ScrollContainer/TableLayout/DragMirrorCheckButton.set_pressed_no_signal(drag_mirrored)
	$Layout/ScrollContainer/TableLayout/VolumeSlider.set_value_no_signal(AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("Master")))

func _on_back_button_pressed() -> void:
	back.emit()

func _on_sensitivity_slider_value_changed(value: float) -> void:
	drag_sensitivity = value / 10000 + 0.00005

func _on_drag_mirror_check_button_toggled(toggled_on: bool) -> void:
	drag_mirrored = toggled_on

func _on_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))
