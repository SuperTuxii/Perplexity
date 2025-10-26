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
signal set_item_slot_visible(slot_visible: bool)
signal set_item_slot(icon: Texture2D)
signal item_slot_pressed
signal drag_tutorial_visible(visible: bool)
signal focus_tutorial_visible(visible: bool)
signal unfocus_tutorial_visible(visible: bool)
signal pause_tutorial_visible(visible: bool)

signal focus_changed(focus: int)
signal finished_focus_change(focus: int)

signal unlock_server(name: String)
signal called_number(number: String)
signal updated_lvl2_unlock

func schedule(callable: Callable, delay: float, ...args: Array):
	if args.size() == 0:
		get_tree().create_timer(delay, false).timeout.connect(callable)
	else:
		get_tree().create_timer(delay, false).timeout.connect(func timeout(): callable.callv(args))
