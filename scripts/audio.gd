class_name Audio extends Node3D

func _ready() -> void:
	EventBus.play_monitor_sound.connect(play_monitor_sound)
	EventBus.set_alarm.connect(set_alarm)
	EventBus.set_alarm_volume.connect(set_alarm_volume)
	EventBus.set_alarm0_volume.connect(set_alarm0_volume)
	EventBus.set_alarm1_volume.connect(set_alarm1_volume)

# Monitor Audio
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
