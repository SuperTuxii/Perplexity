class_name Server extends AnimatedSprite2D

signal pressed
signal button_down
signal button_up

@export
var root_folder_name: String = "Server"

@export
var hacked: bool = false:
	set(value):
		if hacked != value:
			hacked = value
			switch_type()

var pressable: bool = false:
	set(value):
		pressable = value
		$Button.disabled = !value

func _ready() -> void:
	play()
	animation = "hacked_server" if hacked else "normal_server"
	$Button.disabled = !pressable

func switch_type() -> void:
	animation = "changing_server"
	frame = 0 if hacked else sprite_frames.get_frame_count(animation)
	speed_scale = 1 if hacked else -1

func _on_animation_looped() -> void:
	if animation == "changing_server":
		animation = "hacked_server" if hacked else "normal_server"
		frame = randi_range(0, sprite_frames.get_frame_count(animation) - 1)
		speed_scale = randf_range(0.5, 1.5)

func _on_frame_changed() -> void:
	if animation != "changing_server":
		frame = randi_range(0, sprite_frames.get_frame_count(animation) - 1)
		speed_scale = randf_range(0.5, 1.5)

func _on_button_button_down() -> void:
	button_down.emit()
func _on_button_button_up() -> void:
	button_up.emit()
func _on_button_pressed() -> void:
	pressed.emit()
