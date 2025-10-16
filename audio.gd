extends Node3D

const MONITOR_POSITION: Vector3 = Vector3(0.847, 1.125, 1.637)
const MOUSE_POSITION: Vector3 = Vector3(1.266, 0.83, 1.854)

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

signal player_finished(key: String)

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

func play(key: String, sound: AudioStream, volume_db: float, bus: StringName, player_position: Vector3 = Vector3(), player_process_mode: ProcessMode = ProcessMode.PROCESS_MODE_INHERIT) -> void:
	if position.is_zero_approx():
		play_non_positional(key, sound, volume_db, bus, player_process_mode)
	else:
		play_positional(key, sound, volume_db, bus, player_position, player_process_mode)

func play_non_positional(key: String, sound: AudioStream, volume_db: float, bus: StringName, player_process_mode: ProcessMode = ProcessMode.PROCESS_MODE_INHERIT) -> void:
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
		break

func play_positional(key: String, sound: AudioStream, volume_db: float, bus: StringName, player_position: Vector3 = Vector3(), player_process_mode: ProcessMode = ProcessMode.PROCESS_MODE_INHERIT) -> void:
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
		break

func set_volume(key: String, volume_db: float) -> void:
	if key_to_player.has(key):
		key_to_player[key].volume_db = volume_db

func set_player_position(key: String, player_position: Vector3) -> void:
	if key_to_player.has(key):
		key_to_player[key].position = player_position

func _on_player_finished(key: String) -> void:
	if !key_to_player.has(key):
		return
	var player = key_to_player[key]
	key_to_player.erase(key)
	player.finished.disconnect(player.finished.get_connections().back().callable)
	player_finished.emit(key)
