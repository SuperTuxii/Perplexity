class_name Main extends Node3D

@export
var outline_material: Material = preload("res://materials/OutlineMaterial.tres")
@onready
var room: Room = $RoomHighQuality
@onready
var options: OptionsMenu = $PauseMenu/OptionsMenu
@onready
var screen_overlays: ScreenOverlays = $ScreenOverlays

var paused: bool:
	get:
		return $PauseMenu.pause_open
	set(value):
		if value:
			$PauseMenu.show_pause_menu()
		else:
			$PauseMenu.back()

var focus: int = 0:
	set(value):
		room.focus = value
	get:
		return room.focus
var tutorial_stage: int = 0

func _ready() -> void:
	EventBus.play_monitor_sound.connect(play_monitor_sound)
	EventBus.focus_changed.connect(on_focus_changed)
	EventBus.finished_focus_change.connect(finished_focus)
	screen_overlays.show_drag_tutorial()
	screen_overlays.set_skip_button(true)
	screen_overlays.skipped.connect(skip_tutorial)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"): # Pause menu and exiting focus
		if focus <= 0:
			if tutorial_stage == 4:
				screen_overlays.hide_pause_tutorial()
				tutorial_stage = -1
				focus = -1
				room.start_cutscene()
				screen_overlays.skipped.disconnect(skip_tutorial)
				$PauseMenu.continue_to_start_game()
			paused = !paused
		else:
			focus = 0

func on_focus_changed(index: int) -> void:
	if index != -1 and tutorial_stage == -1:
		screen_overlays.set_skip_button(false)
	if index == 1 and tutorial_stage == 1:
		screen_overlays.hide_focus_tutorial()
		screen_overlays.show_unfocus_tutorial()
		tutorial_stage = 3

func finished_focus() -> void:
	# Actions when focus animation finishes
	match focus:
		0:
			if tutorial_stage == 3:
				screen_overlays.hide_unfocus_tutorial()
				screen_overlays.show_pause_tutorial()
				tutorial_stage = 4
		1:
			if $MonitorViewport/MonitorScene.security_breached_visible and tutorial_stage == -1:
				$MonitorViewport/MonitorScene.security_breached_visible = false
				room.alarm_ease_out()

func skip_tutorial() -> void:
	screen_overlays.hide_drag_tutorial()
	screen_overlays.hide_focus_tutorial()
	screen_overlays.hide_unfocus_tutorial()
	screen_overlays.hide_pause_tutorial()
	screen_overlays.skipped.disconnect(skip_tutorial)
	tutorial_stage = -1
	room.start_cutscene()
	$PauseMenu.continue_to_start_game()
	paused = true

# Push input to viewport when monitor is focused (https://github.com/godotengine/godot-demo-projects/tree/master/viewport/gui_in_3d)
var is_mouse_inside = false
var last_event_pos2D = null
var last_event_time: float = -1.0

func _on_screen_area_mouse_entered() -> void:
	is_mouse_inside = true
func _on_screen_area_mouse_exited() -> void:
	is_mouse_inside = false
func _unhandled_input(event):
	for mouse_event in [InputEventMouseButton, InputEventMouseMotion, InputEventScreenDrag, InputEventScreenTouch]:
		if is_instance_of(event, mouse_event):
			return
	$MonitorViewport.push_input(event)
func _on_screen_area_input_event(_camera: Node, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		return
	var collision_shape_size = $"Desk Setup/ScreenArea/CollisionShape3D".shape.size
	var quad_mesh_size = Vector2(collision_shape_size.z, collision_shape_size.y)
	var event_pos3D = event_position
	event_pos3D = $"Desk Setup/ScreenArea".global_transform.affine_inverse() * event_pos3D
	var now: float = Time.get_ticks_msec() / 1000.0
	var event_pos2D: Vector2 = Vector2()
	if is_mouse_inside:
		event_pos2D = Vector2(event_pos3D.z, -event_pos3D.y)
		event_pos2D.x = event_pos2D.x / quad_mesh_size.x
		event_pos2D.y = event_pos2D.y / quad_mesh_size.y
		event_pos2D.x += 0.5
		event_pos2D.y += 0.5
		event_pos2D.x *= $MonitorViewport.size.x
		event_pos2D.y *= $MonitorViewport.size.y
	elif last_event_pos2D != null:
		event_pos2D = last_event_pos2D
	event.position = event_pos2D
	if event is InputEventMouse:
		event.global_position = event_pos2D
	if event is InputEventMouseMotion or event is InputEventScreenDrag:
		if last_event_pos2D == null:
			event.relative = Vector2(0, 0)
		else:
			event.relative = event_pos2D - last_event_pos2D
			event.velocity = event.relative / (now - last_event_time)
	last_event_pos2D = event_pos2D
	last_event_time = now
	$MonitorViewport.push_input(event)

# Monitor Audio
func play_monitor_sound(sound: AudioStream, volume_db: float) -> void:
	var audio_stream = $"Desk Setup/MonitorArea/MonitorAudioStream"
	if audio_stream.playing:
		audio_stream = $"Desk Setup/MonitorArea/MonitorAudioStream2"
	audio_stream.stream = sound
	audio_stream.volume_db = volume_db
	audio_stream.play()

# Door Lock Material
func set_door_lock(locked: bool) -> void:
	var lock_material: StandardMaterial3D = $Door/LockStatus.mesh.surface_get_material(0)
	lock_material.albedo_color = Color(0.9, 0.225, 0.225, 1.0) if locked else Color("#39e639ff")
	lock_material.emission = lock_material.albedo_color
