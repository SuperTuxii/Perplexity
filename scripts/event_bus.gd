@warning_ignore_start("unused_signal")
class_name Events extends Node

signal paused_change(paused: bool)
signal continue_to_back_to_title

#Screen Overlays
signal set_eyelids(close: bool, eyelid_speed: float)
signal set_eyelids_instantly(close: bool)
signal set_subtitles(subtitle: String, stay_seconds: float, subtitle_show_time: float)
signal remove_subtitles
signal remove_subtitles_instantly
signal set_skip_button(visible: bool)
signal skipped
signal set_skip_to_game_button(visible: bool)
signal skipped_to_game
signal drag_tutorial_visible(visible: bool)
signal focus_tutorial_visible(visible: bool)
signal unfocus_tutorial_visible(visible: bool)
signal pause_tutorial_visible(visible: bool)

signal focus_changed(focus: int)
signal finished_focus_change(focus: int)

signal unlock_server(name: String)
signal called_number(number: String)

func schedule(object: Object, function_name: StringName, delay: float):
	get_tree().create_timer(delay, false).timeout.connect(Callable(object, function_name))
