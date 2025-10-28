extends Node3D

const MONITOR_POSITION: Vector3 = Vector3(0.847, 1.125, 1.637)
const MOUSE_POSITION: Vector3 = Vector3(1.266, 0.83, 1.854)
const TELEPHONE_POSITION: Vector3 = Vector3(1.2, 0.829, 1.619)
const CONTAINER_POSITION: Vector3 = Vector3(1.45, 0.3, 4.625)
const DOOR_POSITION: Vector3 = Vector3(0, 1, 5)

@export
var start_music: AudioStream
@export
var after_cutscene_music: AudioStream

# screen overlays
@export
var subtitles: AudioStream
# focus 1 (monitor)
@export
var alarm: AudioStream
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
@export
var correct: AudioStream
@export
var wrong: AudioStream
@export
var mouse_click_press: AudioStream
@export
var mouse_click_release: AudioStream
# focus 2 (telephone)
@export
var button_press: AudioStream
@export
var button_release: AudioStream
@export
var telephone_ringing: AudioStream
@export
var telephone_pickup: AudioStream
# focus 3 (container)
@export
var drawer_open: AudioStream
@export
var drawer_close: AudioStream
@export
var musicbox_windup: AudioStream
@export
var musicbox: AudioStream
# random events
@export
var light_flicker: AudioStream
@export
var door_knock: AudioStream
@export
var door_creek: AudioStream
@export
var door_slam: AudioStream
@export
var door_rattle: AudioStream
@export
var monitor_turn: AudioStream

signal player_finished(key: StringName)

@onready
var positional_audio: Array[AudioStreamPlayer3D] = [
	$AudioStreamPlayer3D,
	$AudioStreamPlayer3D2,
	$AudioStreamPlayer3D3,
	$AudioStreamPlayer3D4
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
