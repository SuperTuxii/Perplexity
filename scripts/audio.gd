class_name Audio extends Node3D

func _ready() -> void:
	EventBus.play_monitor_sound.connect(play_monitor_sound)

# Monitor Audio
func play_monitor_sound(sound: AudioStream, volume_db: float) -> void:
	var audio_stream = $"Desk Setup/MonitorArea/MonitorAudioStream"
	if audio_stream.playing:
		audio_stream = $"Desk Setup/MonitorArea/MonitorAudioStream2"
	audio_stream.stream = sound
	audio_stream.volume_db = volume_db
	audio_stream.play()
