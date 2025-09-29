class_name ScreenOverlays extends Control

@export
var eyes_move_speed: float = 0.5
var eyes_move_weight: float = -1
var eyes_move_from: float = 2
var eyes_move_to: float = 0
var eyes_position: float:
	get:
		return $Eyelids.texture.gradient.get_offset(1)

@export
var subtitles_speed: float = 1
var subtitles_show: bool = false
var subtitles_weight: float:
	get:
		return $SubtitleContainer/Subtitles.visible_ratio
	set(value):
		$SubtitleContainer/Subtitles.visible_ratio = value

func _process(delta: float) -> void:
	if eyes_move_weight != -1:
		eyes_move_weight += delta * eyes_move_speed
		eyes_move_weight = minf(eyes_move_weight, 1)
		$Eyelids.texture.gradient.set_offset(0, lerpf(eyes_move_from, eyes_move_to, eyes_move_weight ** 3)-1)
		$Eyelids.texture.gradient.set_offset(1, lerpf(eyes_move_from, eyes_move_to, eyes_move_weight ** 3))
		if eyes_move_weight == 1:
			eyes_move_weight = -1
	if subtitles_weight != float(subtitles_show):
		subtitles_weight += delta * subtitles_speed * (1 if subtitles_show else -1)
		subtitles_weight = clampf(subtitles_weight, 0, 1)
		if subtitles_weight == 1 and $SubtitleContainer/StayTimer.wait_time != 0:
			$SubtitleContainer/StayTimer.start()
		if subtitles_weight == 0:
			$SubtitleContainer/Subtitles.text = ""

func set_subtitles(subtitle: String, stay_seconds: float = 0, subtitle_speed: float = 1):
	subtitles_show = true
	subtitles_speed = subtitle_speed
	$SubtitleContainer/Subtitles.text = subtitle
	$SubtitleContainer/StayTimer.wait_time = stay_seconds

func remove_subtitles():
	subtitles_show = false
	if !$SubtitleContainer/StayTimer.is_stopped():
		$SubtitleContainer/StayTimer.stop()

func _on_stay_timer_timeout() -> void:
	remove_subtitles()
