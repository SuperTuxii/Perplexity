class_name ScreenOverlays extends Control

signal skipped

@onready
var eyelid_animator: AnimationPlayer = $EyelidAnimator
@onready
var subtitle_animator: AnimationPlayer = $SubtitleContainer/SubtitleAnimator

var eyes_closed: bool:
	get:
		return eyelid_animator.current_animation == "close"

func set_eyelids(close: bool, eyelid_speed: float = 1):
	eyelid_animator.play("close", -1, eyelid_speed * (1 if close else -1), !close)

func set_eyelids_instantly(close: bool):
	eyelid_animator.stop()
	$Eyelids.texture.gradient.offsets[0] = 0 if close else 1
	$Eyelids.texture.gradient.offsets[1] = 0 if close else 1

func set_subtitles(subtitle: String, stay_seconds: float = 0, subtitle_speed: float = 1):
	subtitle_animator.play("show", -1, subtitle_speed)
	$SubtitleContainer/Subtitles.text = subtitle
	$SubtitleContainer/StayTimer.start(stay_seconds)

func remove_subtitles():
	subtitle_animator.play("show", -1, -subtitle_animator.speed_scale, true)
	if !$SubtitleContainer/StayTimer.is_stopped():
		$SubtitleContainer/StayTimer.stop()

func remove_subtitles_instantly():
	$SubtitleContainer/Subtitles.visible_ratio = 0
	subtitle_animator.stop()
	if !$SubtitleContainer/StayTimer.is_stopped():
		$SubtitleContainer/StayTimer.stop()

func set_skip_button(button_visible: bool):
	$MarginContainer/SkipButton.visible = button_visible

func _on_stay_timer_timeout() -> void:
	remove_subtitles()

func _on_skip_button_pressed() -> void:
	skipped.emit()
