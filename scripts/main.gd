class_name Main extends Node3D

@onready
var options: OptionsMenu = $PauseMenu/OptionsMenu
@onready
var screen_overlays: ScreenOverlays = $ScreenOverlays
var audio: Audio
var room: Room

@export
var audio_scenes: Array[PackedScene] = [
	preload("res://scenes/audio/audio_non_positional.tscn"),
	preload("res://scenes/audio/audio_positional.tscn")
]
@export
var room_scenes: Array[PackedScene] = [
	preload("res://scenes/room/room_high_quality.tscn"),
	preload("res://scenes/room/room_low_quality.tscn")
]

var paused: bool:
	get:
		return $PauseMenu.pause_open
	set(value):
		if value:
			$PauseMenu.show_pause_menu()
		else:
			$PauseMenu.back()
var focus: int:
	set(value):
		room.set_focus(value)
	get:
		return room.states.focus

func _ready() -> void:
	load_audio()
	options.room_quality_changed.connect(load_room)
	options.positional_audio_changed.connect(load_audio)
	EventBus.paused_change.connect(on_paused_change)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"): # Pause menu and exiting focus
		if focus <= 0:
			EventBus.paused_change.emit(!paused)
		else:
			focus = 0

func load_audio() -> void:
	if paused and is_inside_tree():
		get_tree().paused = false
	var prev_audio_states: Dictionary
	if audio:
		prev_audio_states = audio.save_states()
		audio.queue_free()
	audio = audio_scenes[int(options.positional_audio)].instantiate()
	add_child(audio)
	if prev_audio_states:
		audio.load_states(prev_audio_states)
	if paused and is_inside_tree():
		get_tree().paused = true

func load_room(create: bool = false, tutorial: bool = false) -> void:
	if !room and !create:
		return
	var prev_room_states: RoomStates = preload("res://room_states.tres")
	if room:
		room.save_transfer_states()
		prev_room_states = room.states
		room.queue_free()
	room = room_scenes[options.room_quality].instantiate()
	room.options = options
	if prev_room_states:
		room.states = prev_room_states
	if tutorial:
		room.states.tutorial_stage = 0
		room.states.cutscene_playing = false
	room.states.paused = paused
	add_child(room)

func on_paused_change(is_paused: bool) -> void:
	if paused != is_paused:
		paused = is_paused

func on_tutorial_finished() -> void:
	room.states.mouse_motion = Vector2()
	room.states.cutscene_playing = true
	room.states.current_cutscene_position = 0
	room.queue_free()
	$TitleScreen.visible = true

func _on_title_screen_start_game() -> void:
	$TitleScreen.visible = false
	load_room(true)

func _on_title_screen_start_tutorial() -> void:
	$TitleScreen.visible = false
	load_room(true, true)
	room.tutorial_finished.connect(on_tutorial_finished)

func _on_title_screen_show_options_menu() -> void:
	$PauseMenu.show_options_menu()
