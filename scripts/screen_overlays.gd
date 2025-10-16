class_name ScreenOverlays extends Control

signal skipped
signal skipped_to_game

@onready
var eyelid_animator: AnimationPlayer = $EyelidAnimator

var subtitle_tween: Tween
var subtitle_time: float

var eyes_closed: bool:
	get:
		return eyelid_animator.current_animation == "close"

func _ready() -> void:
	EventBus.set_eyelids.connect(set_eyelids)
	EventBus.set_eyelids_instantly.connect(set_eyelids_instantly)
	EventBus.set_subtitles.connect(set_subtitles)
	EventBus.remove_subtitles.connect(remove_subtitles)
	EventBus.remove_subtitles_instantly.connect(remove_subtitles_instantly)
	EventBus.set_skip_button.connect(set_skip_button)
	EventBus.set_skip_to_game_button.connect(set_skip_to_game_button)
	EventBus.drag_tutorial_visible.connect(set_drag_tutorial_visible)
	EventBus.focus_tutorial_visible.connect(set_focus_tutorial_visible)
	EventBus.unfocus_tutorial_visible.connect(set_unfocus_tutorial_visible)
	EventBus.pause_tutorial_visible.connect(set_pause_tutorial_visible)

func set_eyelids(close: bool, eyelid_speed: float = 1) -> void:
	eyelid_animator.play("close", -1, eyelid_speed * (1 if close else -1), !close)

func set_eyelids_instantly(close: bool) -> void:
	eyelid_animator.stop()
	$Eyelids.texture.gradient.offsets[0] = 0 if close else 1
	$Eyelids.texture.gradient.offsets[1] = 0 if close else 1

func set_subtitles(subtitle: String, stay_seconds: float = 0, subtitle_show_time: float = 1) -> void:
	if subtitle_tween:
		subtitle_tween.kill()
	subtitle_tween = create_tween()
	subtitle_tween.set_parallel(true)
	subtitle_tween.tween_method(play_subtitle_effects, 0, subtitle.length(), subtitle_show_time)
	subtitle_tween.tween_property($SubtitleContainer/Subtitles, "visible_characters", subtitle.length(), subtitle_show_time)
	subtitle_tween.play()
	subtitle_time = subtitle_show_time
	$SubtitleContainer/Subtitles.visible_characters = 0
	$SubtitleContainer/Subtitles.text = subtitle
	$SubtitleContainer/StayTimer.start(stay_seconds)

func play_subtitle_effects(value) -> void:
	if !Audio.is_playing("subtitles") and $SubtitleContainer/Subtitles.visible_characters != value:
		Audio.play("subtitles", Audio.subtitles, -20, "SFX")

func remove_subtitles(time: float = subtitle_time) -> void:
	if subtitle_tween:
		subtitle_tween.kill()
	subtitle_tween = create_tween()
	subtitle_tween.tween_property($SubtitleContainer/Subtitles, "visible_characters", 0, time)
	subtitle_tween.play()
	if !$SubtitleContainer/StayTimer.is_stopped():
		$SubtitleContainer/StayTimer.stop()

func remove_subtitles_instantly() -> void:
	$SubtitleContainer/Subtitles.visible_characters = 0
	if subtitle_tween:
		subtitle_tween.kill()
	if !$SubtitleContainer/StayTimer.is_stopped():
		$SubtitleContainer/StayTimer.stop()

func set_skip_button(button_visible: bool) -> void:
	$MarginContainer/HBoxContainer/SkipButton.visible = button_visible

func set_skip_to_game_button(button_visible: bool) -> void:
	$MarginContainer/HBoxContainer/SkipToGameButton.visible = button_visible

func set_drag_tutorial_visible(tutorial_visible: bool) -> void:
	$DragTutorial.visible = tutorial_visible
func set_focus_tutorial_visible(tutorial_visible: bool) -> void:
	$FocusTutorial.visible = tutorial_visible
func set_unfocus_tutorial_visible(tutorial_visible: bool) -> void:
	$UnfocusTutorial.visible = tutorial_visible
func set_pause_tutorial_visible(tutorial_visible: bool) -> void:
	$PauseTutorial.visible = tutorial_visible

func _on_stay_timer_timeout() -> void:
	remove_subtitles()

func _on_skip_button_pressed() -> void:
	skipped.emit()
	EventBus.skipped.emit()

func _on_skip_to_game_button_pressed() -> void:
	skipped_to_game.emit()
	EventBus.skipped_to_game.emit()
