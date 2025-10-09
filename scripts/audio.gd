class_name Audio extends Node

func _ready() -> void:
	EventBus.play_monitor_sound.connect(play_monitor_sound)
	EventBus.set_alarm.connect(set_alarm)
	EventBus.set_alarm_volume.connect(set_alarm_volume)
	EventBus.set_alarm0_volume.connect(set_alarm0_volume)
	EventBus.set_alarm1_volume.connect(set_alarm1_volume)

func save_states() -> Dictionary:
	var states: Dictionary = {}
	states["AlarmAudioStream"] = {
		"playing": $AlarmAudioStream.playing,
		"position": $AlarmAudioStream.get_playback_position(),
		"volume": $AlarmAudioStream.volume_db,
		"alarm0_volume": $AlarmAudioStream.stream.get_sync_stream_volume(0),
		"alarm1_volume": $AlarmAudioStream.stream.get_sync_stream_volume(1)
	}
	states["MonitorAudioStream"] = {
		"stream": $MonitorAudioStream.stream,
		"playing": $MonitorAudioStream.playing,
		"position": $MonitorAudioStream.get_playback_position(),
		"volume": $MonitorAudioStream.volume_db,
	}
	states["MonitorAudioStream2"] = {
		"stream": $MonitorAudioStream2.stream,
		"playing": $MonitorAudioStream2.playing,
		"position": $MonitorAudioStream2.get_playback_position(),
		"volume": $MonitorAudioStream2.volume_db,
	}
	print(states)
	return states

func load_states(states: Dictionary) -> void:
	set_alarm(states["AlarmAudioStream"].playing)
	$AlarmAudioStream.seek(states["AlarmAudioStream"].position)
	set_alarm_volume(states["AlarmAudioStream"].volume)
	set_alarm0_volume(states["AlarmAudioStream"].alarm0_volume)
	set_alarm1_volume(states["AlarmAudioStream"].alarm1_volume)
	$MonitorAudioStream.stream = states["MonitorAudioStream"].stream
	$MonitorAudioStream.playing = states["MonitorAudioStream"].playing
	$MonitorAudioStream.seek(states["MonitorAudioStream"].position)
	$MonitorAudioStream.volume_db = states["MonitorAudioStream"].volume
	$MonitorAudioStream2.stream = states["MonitorAudioStream2"].stream
	$MonitorAudioStream2.playing = states["MonitorAudioStream2"].playing
	$MonitorAudioStream2.seek(states["MonitorAudioStream2"].position)
	$MonitorAudioStream2.volume_db = states["MonitorAudioStream2"].volume

func play_monitor_sound(sound: AudioStream, volume_db: float) -> void:
	var audio_stream = $MonitorAudioStream
	if audio_stream.playing:
		audio_stream = $MonitorAudioStream2
	audio_stream.stream = sound
	audio_stream.volume_db = volume_db
	audio_stream.play()

func set_alarm(playing: bool) -> void:
	$AlarmAudioStream.playing = playing

func set_alarm_volume(volume: float) -> void:
	$AlarmAudioStream.volume_db = volume

func set_alarm0_volume(volume: float) -> void:
	$AlarmAudioStream.stream.set_sync_stream_volume(0, volume)

func set_alarm1_volume(volume: float) -> void:
	$AlarmAudioStream.stream.set_sync_stream_volume(1, volume)
