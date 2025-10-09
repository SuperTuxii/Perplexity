class_name Room extends Node3D

@export
var outline_material: Material = preload("res://materials/OutlineMaterial.tres")
@onready
var camera: Camera3D = $"Desk Setup/Chair/Camera"
@onready
var monitor_viewport: SubViewport = $MonitorViewport
var options: OptionsMenu
var states: RoomStates

func _ready() -> void:
	_process(0)
	EventBus.paused_change.connect(on_paused_change)
	EventBus.play_monitor_sound.connect(play_monitor_sound)
	if states.tutorial_stage == 0:
		EventBus.drag_tutorial_visible.emit(true)
		EventBus.set_skip_button.emit(true)
		EventBus.skipped.connect(skip_tutorial)
	if states.current_cutscene:
		$CutsceneAnimator.play(states.current_cutscene, -1, states.cutscene_speed_scale)
		$CutsceneAnimator.seek(states.current_cutscene_position)

func _exit_tree() -> void:
	print("exit")
	EventBus.paused_change.disconnect(on_paused_change)
	EventBus.play_monitor_sound.disconnect(play_monitor_sound)
	if EventBus.skipped.is_connected(skip_tutorial):
		EventBus.skipped.disconnect(skip_tutorial)
	if EventBus.skipped.is_connected(skip_cutscene):
		EventBus.skipped.disconnect(skip_cutscene)
	states.current_cutscene = $CutsceneAnimator.current_animation
	if $CutsceneAnimator.is_playing():
		states.current_cutscene_position = $CutsceneAnimator.current_animation_position
		states.cutscene_speed_scale = $CutsceneAnimator.speed_scale

func _process(delta: float) -> void:
	if states.focus == 0 and states.focus_weight == -1: # Applying screen drag when focus is 0
		states.mouse_motion.y = clamp(states.mouse_motion.y, -1.56, 1.56)
		camera.transform.basis = Basis.from_euler(Vector3(states.mouse_motion.y, 0, 0))
		$"Desk Setup/Chair".transform.basis = Basis.from_euler(Vector3(0, states.mouse_motion.x, 0))
	if states.focus_weight != -1: # Focus animation
		states.focus_weight += delta * states.focus_speed
		states.focus_weight = minf(states.focus_weight, 1)
		camera.position = states.focus_from_position.slerp(states.focus_to_position, states.focus_weight)
		camera.rotation = states.focus_from_rotation.slerp(states.focus_to_rotation * (PI / 180), states.focus_weight)
		if states.focus_weight == 1:
			camera.position = states.focus_to_position
			camera.rotation = states.focus_to_rotation * (PI / 180)
			states.focus_weight = -1
			finished_focus()

func set_focus(index: int) -> void:
	if get_tree().has_group("focus_" + str(states.focus) + "_hide"):
		for object in get_tree().get_nodes_in_group("focus_" + str(states.focus) + "_hide"):
				object.visible = true
	states.focus = index
	EventBus.focus_changed.emit(index)
	if index != -1 and states.tutorial_stage == -1:
		EventBus.set_skip_button.emit(false)
	if index == 1 and states.tutorial_stage == 1:
		EventBus.focus_tutorial_visible.emit(false)
		EventBus.unfocus_tutorial_visible.emit(true)
		states.tutorial_stage = 3
	if index == -1:
		return # Other focus like a cutscene
	# Focus animation configuration
	match index:
		0: # No focus/on chair
			states.mouse_motion.y = 0
			camera.reparent($"Desk Setup/Chair")
			states.focus_to_position = Vector3(0, 1.2, 0)
			states.focus_to_rotation = Vector3()
		1: # Monitor focused
			$"Desk Setup/Monitor/Monitor".material_overlay = null
			camera.reparent($"Desk Setup/Monitor")
			states.focus_to_position = Vector3(0.3, 0.34, 0)
			states.focus_to_rotation = Vector3(0, 90, 0)
	states.focus_from_position = camera.position
	states.focus_from_rotation = camera.rotation
	states.focus_weight = 0

func finished_focus() -> void:
	EventBus.finished_focus_change.emit(states.focus)
	# Actions when focus animation finishes
	match states.focus:
		0:
			if states.tutorial_stage == 3:
				EventBus.unfocus_tutorial_visible.emit(false)
				EventBus.pause_tutorial_visible.emit(true)
				states.tutorial_stage = 4
		1:
			if $MonitorViewport/MonitorScene.security_breached_visible and states.tutorial_stage == -1:
				$MonitorViewport/MonitorScene.security_breached_visible = false
				$CutsceneAnimator.play("alarm_ease_out")
	if get_tree().has_group("focus_" + str(states.focus) + "_hide"):
		for object in get_tree().get_nodes_in_group("focus_" + str(states.focus) + "_hide"):
				object.visible = false

func on_paused_change(is_paused: bool) -> void:
	states.paused = is_paused
	if states.tutorial_stage == 4:
		EventBus.pause_tutorial_visible.emit(false)
		states.tutorial_stage = -1
		set_focus(-1)
		EventBus.skipped.disconnect(skip_tutorial)
		start_cutscene.call_deferred() # Called deffered otherwise instantly skipped
		EventBus.continue_to_start_game.emit()

func skip_tutorial() -> void:
	set_focus(0)
	states.focus_weight = 1
	_process(0)
	EventBus.drag_tutorial_visible.emit(false)
	EventBus.focus_tutorial_visible.emit(false)
	EventBus.unfocus_tutorial_visible.emit(false)
	EventBus.pause_tutorial_visible.emit(false)
	EventBus.skipped.disconnect(skip_tutorial)
	states.tutorial_stage = -1
	start_cutscene.call_deferred()
	EventBus.continue_to_start_game.emit()
	EventBus.paused_change.emit(true)

func start_cutscene() -> void:
	set_focus(-1)
	$CutsceneAnimator.play("start_sleep")
	EventBus.set_skip_button.emit(true)
	EventBus.skipped.connect(skip_cutscene)

func skip_cutscene() -> void:
	EventBus.set_skip_button.emit(false)
	EventBus.skipped.disconnect(skip_cutscene)
	$CutsceneAnimator.play("skip_" + $CutsceneAnimator.current_animation)
	camera.rotation.x = 0

func finish_cutscene() -> void:
	EventBus.set_skip_button.emit(false)
	EventBus.skipped.disconnect(skip_cutscene)
	set_focus(0)

func _input(event: InputEvent) -> void:
	if !states.paused and states.focus == 0 and states.focus_weight == -1: # Saving screen drag when focus is 0
		if event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			states.mouse_pressed = event.pressed
			if event.pressed:
				states.mouse_movement = 0
		if event is InputEventMouseMotion and states.mouse_pressed:
			states.mouse_motion += event.relative * options.turn_sensitivity * (-1 if !options.drag_mirrored else 1)
			states.mouse_movement += (event.relative * options.turn_sensitivity).length()
			if states.tutorial_stage == 0 and states.mouse_movement > 0.5:
				EventBus.drag_tutorial_visible.emit(false)
				EventBus.focus_tutorial_visible.emit(true)
				states.tutorial_stage = 1

# Monitor hover and focus
func _on_monitor_area_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
		if !event.pressed and states.focus == 0 and states.mouse_movement < 0.05 and states.tutorial_stage != 0:
			set_focus(1)
func _on_monitor_area_mouse_entered() -> void:
	if states.focus == 0 and states.focus_weight == -1:
		$"Desk Setup/Monitor/Monitor".material_overlay = outline_material
func _on_monitor_area_mouse_exited() -> void:
	$"Desk Setup/Monitor/Monitor".material_overlay = null

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
	monitor_viewport.push_input(event)
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
		event_pos2D.x *= monitor_viewport.size.x
		event_pos2D.y *= monitor_viewport.size.y
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
	monitor_viewport.push_input(event)

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

#Functions for CutsceneAnimator
func set_security_breached(security_breached_visible: bool) -> void:
	$MonitorViewport/MonitorScene.security_breached_visible = security_breached_visible

func set_eyelids(close: bool, eyelid_speed: float) -> void:
	EventBus.set_eyelids.emit(close, eyelid_speed)

func set_eyelids_instantly(close: bool) -> void:
	EventBus.set_eyelids_instantly.emit(close)

func set_subtitles(subtitle: String, stay_seconds: float, subtitle_show_time: float) -> void:
	EventBus.set_subtitles.emit(subtitle, stay_seconds, subtitle_show_time)

func remove_subtitles_instantly() -> void:
	EventBus.remove_subtitles_instantly.emit()
