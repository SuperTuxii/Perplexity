extends Node3D

const MONITOR_POSITION: Vector3 = Vector3(0.847, 1.125, 1.637)
const MOUSE_POSITION: Vector3 = Vector3(1.266, 0.83, 1.854)

@export
var start_music: AudioStream
@export
var after_cutscene_music: AudioStream

@export
var subtitles: AudioStream
@export
var alarm: AudioStream
@export
var mouse_click_press: AudioStream = preload("res://assets/audio/mouse_press.mp3")
@export
var mouse_click_release: AudioStream = preload("res://assets/audio/mouse_release.mp3")
@export
var light_flicker: AudioStream
@export
var mask_server_hack: AudioStream
@export
var mask_final_server_hack: AudioStream
@export
var mask_server_start_hack: AudioStream
@export
var mask_final_server_start_hack: AudioStream
@export
var server_unlock: AudioStream

signal player_finished(key: StringName)

@onready
var positional_audio: Array[AudioStreamPlayer3D] = [
	$AudioStreamPlayer3D,
	$AudioStreamPlayer3D2,
	$AudioStreamPlayer3D3
]
@onready
var non_positional_audio: Array[AudioStreamPlayer] = [
	$AudioStreamPlayer,
	$AudioStreamPlayer2,
	$AudioStreamPlayer3
]

var key_to_player: Dictionary = {}

func play(key: StringName, sound: AudioStream, volume_db: float, bus: StringName, player_position: Vector3 = Vector3(), player_process_mode: ProcessMode = ProcessMode.PROCESS_MODE_INHERIT) -> void:
	if player_position.is_zero_approx():
		play_non_positional(key, sound, volume_db, bus, player_process_mode)
	else:
		play_positional(key, sound, volume_db, bus, player_position, player_process_mode)

func play_non_positional(key: StringName, sound: AudioStream, volume_db: float, bus: StringName, player_process_mode: ProcessMode = ProcessMode.PROCESS_MODE_INHERIT) -> void:
	if key_to_player.has(key):
		return
	for player in non_positional_audio:
		if player.playing:
			continue
		player.stream = sound
		player.volume_db = volume_db
		player.bus = bus
		player.process_mode = player_process_mode
		player.finished.connect(func on_finished(): _on_player_finished(key))
		player.play()
		key_to_player[key] = player
		return
	push_warning("Not enough non positional audio players! Audio with the key " + key + " was just skipped.")

func play_positional(key: StringName, sound: AudioStream, volume_db: float, bus: StringName, player_position: Vector3 = Vector3(), player_process_mode: ProcessMode = ProcessMode.PROCESS_MODE_INHERIT) -> void:
	if key_to_player.has(key):
		return
	for player in positional_audio:
		if player.playing:
			continue
		player.stream = sound
		player.volume_db = volume_db
		player.bus = bus
		player.position = player_position
		player.process_mode = player_process_mode
		player.finished.connect(func on_finished(): _on_player_finished(key))
		player.play()
		key_to_player[key] = player
		return
	push_warning("Not enough positional audio players! Audio with the key " + key + " was just skipped.")

func play_again(key: StringName) -> void:
	if key_to_player.has(key):
		key_to_player[key].play()

func stop(key: StringName) -> void:
	if key_to_player.has(key):
		var player = key_to_player[key]
		player.stop()
		key_to_player.erase(key)
		player.finished.disconnect(player.finished.get_connections().back().callable)

func set_volume(key: StringName, volume_db: float) -> void:
	if key_to_player.has(key):
		key_to_player[key].volume_db = volume_db

func set_player_position(key: StringName, player_position: Vector3) -> void:
	if key_to_player.has(key):
		key_to_player[key].position = player_position

func is_playing(key: StringName) -> bool:
	return key_to_player.has(key)

func _on_player_finished(key: StringName) -> void:
	if !key_to_player.has(key):
		return
	var player = key_to_player[key]
	player_finished.emit(key)
	if !player.playing:
		key_to_player.erase(key)
		player.finished.disconnect(player.finished.get_connections().back().callable)
