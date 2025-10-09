class_name Main extends Node3D

@onready
var options: OptionsMenu = $PauseMenu/OptionsMenu
@onready
var screen_overlays: ScreenOverlays = $ScreenOverlays
var room: Room

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
	load_room()
	options.room_quality_changed.connect(load_room)
	EventBus.paused_change.connect(on_paused_change)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"): # Pause menu and exiting focus
		if focus <= 0:
			EventBus.paused_change.emit(!paused)
		else:
			focus = 0

func load_room() -> void:
	var prev_room_states: RoomStates = preload("res://room_states.tres")
	if room:
		room.save_transfer_states()
		prev_room_states = room.states
		room.queue_free()
	room = room_scenes[options.room_quality].instantiate()
	room.options = options
	if prev_room_states:
		room.states = prev_room_states
	room.states.paused = paused
	add_child(room)

func on_paused_change(is_paused: bool) -> void:
	if paused != is_paused:
		paused = is_paused
