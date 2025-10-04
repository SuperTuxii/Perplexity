class_name OptionsMenu extends PanelContainer

signal back

@export
var bus_layout: AudioBusLayout = preload("res://default_bus_layout.tres")
@export
var turn_sensitivity: float = 0.005
@export
var drag_mirrored: bool = false
@export
var volume: float = 1.0
@export
var music_volume: float = 1.0
@export
var sfx_volume: float = 1.0

func _ready() -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(music_volume))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(sfx_volume))

func _on_visibility_changed() -> void:
	if !is_node_ready():
		return
	$Layout/ScrollContainer/TableLayout/SensitivitySlider.set_value_no_signal((turn_sensitivity - 0.00005) * 10000)
	$Layout/ScrollContainer/TableLayout/DragMirrorCheckButton.set_pressed_no_signal(drag_mirrored)
	$Layout/ScrollContainer/TableLayout/VolumeSlider.set_value_no_signal(AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("Master")))
	$Layout/ScrollContainer/TableLayout/MusicVolumeSlider.set_value_no_signal(AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("Music")))
	$Layout/ScrollContainer/TableLayout/SFXVolumeSlider.set_value_no_signal(AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("SFX")))

func _on_back_button_pressed() -> void:
	back.emit()

func _on_sensitivity_slider_value_changed(value: float) -> void:
	turn_sensitivity = value / 10000 + 0.00005

func _on_drag_mirror_check_button_toggled(toggled_on: bool) -> void:
	drag_mirrored = toggled_on

func _on_volume_slider_value_changed(value: float) -> void:
	volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))

func _on_music_volume_slider_value_changed(value: float) -> void:
	music_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))

func _on_sfx_volume_slider_value_changed(value: float) -> void:
	sfx_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))
