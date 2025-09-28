class_name ScreenOverlays extends Control

@export
var eyes_move_speed: float = 0.5
var eyes_move_time: float = -1
var eyes_move_from: float = 2
var eyes_move_to: float = 0

func _process(delta: float) -> void:
	if eyes_move_time != -1:
		eyes_move_time += delta * eyes_move_speed
		eyes_move_time = minf(eyes_move_time, 1)
		$Eyelids.texture.gradient.set_offset(0, lerpf(eyes_move_from, eyes_move_to, eyes_move_time ** 3)-1)
		$Eyelids.texture.gradient.set_offset(1, lerpf(eyes_move_from, eyes_move_to, eyes_move_time ** 3))
		if eyes_move_time == 1:
			eyes_move_time = -1
