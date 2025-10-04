class_name MusicPlayer extends AudioStreamPlayer

@export
var start_music: AudioStream
@export
var after_cutscene_music: AudioStream

var fade_tween: Tween

func _ready() -> void:
	EventBus.play_music.connect(play_music)
	EventBus.play_music.emit(start_music, linear_to_db(0.4))

func play_music(music: AudioStream, volume: float, fade_in_time: float = 0) -> void:
	stream = music
	if fade_in_time > 0:
		if fade_tween:
			fade_tween.kill()
		fade_tween = create_tween()
		fade_tween.tween_property(self, "volume_db", volume, fade_in_time)
		fade_tween.play()
	else:
		volume_db = volume
	play()

func fade_out(time: float) -> void:
	if fade_tween:
		fade_tween.kill()
	fade_tween = create_tween()
	fade_tween.tween_property(self, "volume_db", -80, time)
	fade_tween.tween_callback(self.stop)
	fade_tween.play()

func fade_into_after_cutscene_music(time: float) -> void:
	play_music(after_cutscene_music, linear_to_db(0.4), time)

func _on_finished() -> void:
	play()
