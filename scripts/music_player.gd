class_name MusicPlayer extends AudioStreamPlayer

@export
var start_music: AudioStream
@export
var after_cutscene_music: AudioStream

func _ready() -> void:
	EventBus.play_music.connect(play_music)
	EventBus.play_music.emit(start_music, linear_to_db(0.4))

func play_music(music: AudioStream, volume: float) -> void:
	stream = music
	volume_db = volume
	play()

func fade_out(time: float) -> void:
	$AnimationPlayer.play("fade", -1, 1/time)

func fade_in(time: float) -> void:
	$AnimationPlayer.play("fade", -1, -1/time, true)

func _on_finished() -> void:
	play()
