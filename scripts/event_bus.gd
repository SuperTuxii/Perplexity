@warning_ignore_start("unused_signal")
class_name Events extends Node

signal paused_change(paused: bool)
signal continue_to_start_game

#Screen Overlays
signal set_eyelids(close: bool, eyelid_speed: float)
signal set_eyelids_instantly(close: bool)
signal set_subtitles(subtitle: String, stay_seconds: float, subtitle_show_time: float)
signal remove_subtitles
signal remove_subtitles_instantly
signal set_skip_button(visible: bool)
signal skipped
signal drag_tutorial_visible(visible: bool)
signal focus_tutorial_visible(visible: bool)
signal unfocus_tutorial_visible(visible: bool)
signal pause_tutorial_visible(visible: bool)

signal play_monitor_sound(sound: AudioStream, volume_db: float)
signal play_music(music: AudioStream, volume_db: float)
signal music_fade_out(time: float)
signal fade_into_after_cutscene_music(time: float)
signal focus_changed(focus: int)
signal finished_focus_change(focus: int)

func schedule(object: Object, function_name: StringName, delay: float):
	get_tree().create_timer(delay, false).timeout.connect(Callable(object, function_name))
