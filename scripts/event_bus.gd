@warning_ignore_start("unused_signal")
class_name Events extends Node

#Screen Overlays
signal set_eyelids(close: bool, eyelid_speed: float)
signal set_eyelids_instantly(close: bool)
signal set_subtitles(subtitle: String, stay_seconds: float, subtitle_speed: float)
signal remove_subtitles
signal remove_subtitles_instantly
signal set_skip_button(visible: bool)
signal skipped

signal play_monitor_sound(sound: AudioStream, volume_db: float)
signal focus_changed(focus: int)
signal finished_focus_change(focus: int)
