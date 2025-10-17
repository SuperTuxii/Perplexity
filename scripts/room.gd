class_name Room extends Node3D

signal tutorial_finished

@export
var shadow_quality: int = 2
@export
var monitor_scene: PackedScene = preload("res://scenes/monitor_scenes/monitor_scene.tscn")
@export
var outline_material: Material = preload("res://materials/OutlineMaterial.tres")
@export
var light_frame_material: Material = preload("res://materials/room/light/LightFrameMaterial.tres")
@onready
var camera: Camera3D = $"Desk Setup/Chair/Camera"
@onready
var monitor_viewport: SubViewport = $MonitorViewport
@onready
var monitor_mesh: MeshInstance3D = $"Desk Setup/Monitor/Monitor"
@onready
var telephone_mesh: MeshInstance3D = $"Desk Setup/Telephone/Telephone Base Bottom/Telephone Base Top"
@onready
var telephone_receiver_mesh: MeshInstance3D = $"Desk Setup/Telephone/Telephone Base Bottom/Telephone Base Top/Telephone Receiver"

var options: OptionsMenu
var states: RoomStates

@export
var time_random_events_interval: float = 15
var time_random_events_pool: Dictionary = {
	6: null,
	8: light_flicker,
	9: knock_door
}

func _ready() -> void:
	ProjectSettings.set_setting("rendering/lights_and_shadows/directional_shadow/soft_shadow_filter_quality", shadow_quality)
	ProjectSettings.set_setting("rendering/lights_and_shadows/positional_shadow/soft_shadow_filter_quality", shadow_quality)
	EventBus.paused_change.connect(_on_paused_change)
	if states.tutorial_stage == 0:
		EventBus.drag_tutorial_visible.emit(true)
		EventBus.set_skip_button.emit(true)
		EventBus.skipped.connect(skip_tutorial)
	if !states.monitor_scene:
		states.monitor_scene = monitor_scene.instantiate()
	$MonitorViewport.add_child(states.monitor_scene)
	if states.cutscene_playing:
		start_cutscene()
		$CutsceneAnimator.seek(states.current_cutscene_position, true)
	monitor_mesh.material_overlay = outline_material.duplicate()
	monitor_mesh.material_overlay.albedo_color.a = 0
	telephone_mesh.material_overlay = outline_material.duplicate()
	telephone_receiver_mesh.material_overlay = outline_material.duplicate()
	telephone_mesh.material_overlay.albedo_color.a = 0
	for i in range(12):
		var button: MeshInstance3D = get_node("Desk Setup/Telephone/Telephone Base Bottom/Telephone Base Top/Button " + str(i))
		button.material_overlay = outline_material.duplicate()
		button.material_overlay.albedo_color.a = 0
	EventBus.schedule(self, "roll_random_event", time_random_events_interval)
	# Taking pictures of viewport for cube map
	#if has_node("Camera3D"):
		#$Camera3D.make_current()
		#states.monitor_scene.security_breached_visible = true
		#set_door_lock(true)
		#EventBus.schedule(self, "take_picture", 1.0)
#
#func take_picture() -> void:
	#var image = get_viewport().get_texture().get_image()
	#var timestamp = str(Time.get_datetime_string_from_system())
	#print(image.save_png("user://screenshot_" + timestamp + ".png"))

func _exit_tree() -> void:
	EventBus.paused_change.disconnect(_on_paused_change)
	if EventBus.skipped.is_connected(skip_tutorial):
		EventBus.skipped.disconnect(skip_tutorial)
	if EventBus.skipped.is_connected(skip_cutscene):
		EventBus.skipped.disconnect(skip_cutscene)

func save_transfer_states() -> void:
	$MonitorViewport.remove_child(states.monitor_scene)
	states.cutscene_playing = $CutsceneAnimator.current_animation == "start_sleep"
	if states.cutscene_playing:
		states.current_cutscene_position = $CutsceneAnimator.current_animation_position

func _process(_delta: float) -> void:
	if states.focus == 0 and !states.focussing: # Applying screen drag when focus is 0
		states.mouse_motion.y = clamp(states.mouse_motion.y, -1.56, 1.56)
		camera.transform.basis = Basis.from_euler(Vector3(states.mouse_motion.y, 0, 0))
		$"Desk Setup/Chair".transform.basis = Basis.from_euler(Vector3(0, states.mouse_motion.x, 0))

func get_focus_state(index: int) -> Dictionary:
	match index:
		0:
			return { "position": Vector3(0, 1.2, 0), "rotation": Vector3(), "parent": $"Desk Setup/Chair" }
		1:
			return { "position": Vector3(0.3, 0.34, 0), "rotation": Vector3(0, 90, 0), "parent": $"Desk Setup/Monitor" }
		2:
			return { "position": Vector3(-0.005, 0.19, -0.1), "rotation": Vector3(-65, -182.1, 5), "parent": $"Desk Setup/Telephone" }
	return { "position": Vector3(0, 1.2, 0), "rotation": Vector3(), "parent": $"Desk Setup/Chair" }

func set_focus(index: int) -> void:
	if get_tree().has_group("focus_" + str(states.focus) + "_hide"):
		for object in get_tree().get_nodes_in_group("focus_" + str(states.focus) + "_hide"):
				object.visible = true
	states.focus = index
	EventBus.focus_changed.emit(index)
	if index != -1 and states.tutorial_stage == -1:
		EventBus.set_skip_button.emit(false)
		EventBus.set_skip_to_game_button.emit(false)
	if index == 1 and states.tutorial_stage == 1:
		EventBus.focus_tutorial_visible.emit(false)
		states.monitor_scene.start_tutorial()
		EventBus.unlock_server.connect(_on_unlock_server)
		states.tutorial_stage = 2
	if index == -1:
		return # Other focus like a cutscene
	# Focus animation configuration
	if states.focus_tween:
		states.focus_tween.kill()
	states.focus_tween = create_tween()
	states.focus_tween.set_parallel()
	match index:
		0:
			states.mouse_motion.y = 0
			telephone_receiver_mesh.material_overlay.albedo_color.a = 0
		1:
			monitor_mesh.material_overlay.albedo_color.a = 0
		2:
			telephone_mesh.material_overlay.albedo_color.a = 0
			telephone_receiver_mesh.material_overlay.albedo_color.a = 0
	var state: Dictionary = get_focus_state(index)
	camera.reparent(state.parent)
	states.focus_tween.tween_property(camera, "position",  state.position, states.focus_time)
	states.focus_tween.tween_property(camera, "rotation_degrees", state.rotation, states.focus_time)
	var finish_tween: Tween = create_tween()
	finish_tween.tween_interval(states.focus_time)
	finish_tween.tween_callback(finished_focus)
	states.focus_tween.tween_subtween(finish_tween)
	states.focus_tween.set_trans(Tween.TRANS_QUAD)

func set_focus_instantly(index: int) -> void:
	if get_tree().has_group("focus_" + str(states.focus) + "_hide"):
		for object in get_tree().get_nodes_in_group("focus_" + str(states.focus) + "_hide"):
				object.visible = true
	states.focus = index
	EventBus.focus_changed.emit(index)
	if index != -1 and states.tutorial_stage == -1:
		EventBus.set_skip_button.emit(false)
		EventBus.set_skip_to_game_button.emit(false)
	if index == -1:
		return # Other focus like a cutscene
	match index:
		0:
			states.mouse_motion.y = 0
			telephone_receiver_mesh.material_overlay.albedo_color.a = 0
		1:
			monitor_mesh.material_overlay.albedo_color.a = 0
		2:
			telephone_mesh.material_overlay.albedo_color.a = 0
			telephone_receiver_mesh.material_overlay.albedo_color.a = 0
	var state: Dictionary = get_focus_state(index)
	camera.reparent(state.parent)
	camera.position = state.position
	camera.rotation_degrees = state.rotation
	finished_focus()

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
			if states.monitor_scene.security_breached_visible and states.tutorial_stage == -1:
				states.monitor_scene.security_breached_visible = false
				$CutsceneAnimator.play("alarm_ease_out")
	if get_tree().has_group("focus_" + str(states.focus) + "_hide"):
		for object in get_tree().get_nodes_in_group("focus_" + str(states.focus) + "_hide"):
				object.visible = false

func _on_paused_change(is_paused: bool) -> void:
	states.paused = is_paused
	if states.tutorial_stage == 4:
		EventBus.pause_tutorial_visible.emit(false)
		EventBus.set_skip_button.emit(false)
		EventBus.skipped.disconnect(skip_tutorial)
		EventBus.continue_to_back_to_title.emit()
		states.tutorial_stage = 5
	elif states.tutorial_stage == 5:
		states.monitor_scene.finish_tutorial()
		states.tutorial_stage = -1
		tutorial_finished.emit()

func _on_unlock_server(_name: String) -> void:
	EventBus.unlock_server.disconnect(_on_unlock_server)
	EventBus.unfocus_tutorial_visible.emit(true)
	states.tutorial_stage = 3

func skip_tutorial() -> void:
	set_focus_instantly(0)
	EventBus.drag_tutorial_visible.emit(false)
	EventBus.focus_tutorial_visible.emit(false)
	EventBus.unfocus_tutorial_visible.emit(false)
	EventBus.pause_tutorial_visible.emit(false)
	EventBus.set_skip_button.emit(false)
	EventBus.skipped.disconnect(skip_tutorial)
	states.monitor_scene.finish_tutorial()
	states.tutorial_stage = -1
	tutorial_finished.emit()

func start_cutscene() -> void:
	set_focus(-1)
	$CutsceneAnimator.play("start_sleep")
	EventBus.set_skip_button.emit(true)
	EventBus.skipped.connect(skip_cutscene)
	EventBus.set_skip_to_game_button.emit(true)
	EventBus.skipped_to_game.connect(skip_to_game)

func skip_cutscene() -> void:
	EventBus.set_skip_button.emit(false)
	EventBus.skipped.disconnect(skip_cutscene)
	EventBus.set_skip_to_game_button.emit(false)
	EventBus.skipped_to_game.disconnect(skip_to_game)
	$CutsceneAnimator.play("skip_" + $CutsceneAnimator.current_animation)
	camera.rotation.x = 0

func finish_cutscene() -> void:
	EventBus.set_skip_button.emit(false)
	EventBus.skipped.disconnect(skip_cutscene)
	EventBus.set_skip_to_game_button.emit(false)
	EventBus.skipped_to_game.disconnect(skip_to_game)
	set_focus(0)

func skip_to_game() -> void:
	EventBus.set_skip_button.emit(false)
	EventBus.skipped.disconnect(skip_cutscene)
	EventBus.set_skip_to_game_button.emit(false)
	EventBus.skipped_to_game.disconnect(skip_to_game)
	set_door_lock(true)
	remove_subtitles_instantly()
	set_eyelids_instantly(false)
	set_security_breached(true)
	fade_into_after_cutscene_music(0)
	set_focus_instantly(1)
	EventBus.skipped.emit()

func _input(event: InputEvent) -> void:
	if !states.paused and states.focus == 0 and !states.focussing: # Saving screen drag when focus is 0
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

#region Monitor hover and focus
func _on_monitor_area_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
		if !event.pressed and states.focus == 0 and states.mouse_movement < 0.05 and states.tutorial_stage != 0:
			set_focus(1)
func _on_monitor_area_mouse_entered() -> void:
	if states.focus == 0 and !states.focussing:
		monitor_mesh.material_overlay.albedo_color.a = 1
func _on_monitor_area_mouse_exited() -> void:
	monitor_mesh.material_overlay.albedo_color.a = 0
#endregion
#region Push input to viewport when monitor is focused (https://github.com/godotengine/godot-demo-projects/tree/master/viewport/gui_in_3d)
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
#endregion
#region Telephone hover and focus
func _on_telephone_area_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
		if !event.pressed and states.focus == 0 and states.mouse_movement < 0.05 and states.tutorial_stage != 0:
			set_focus(2)
func _on_telephone_area_mouse_entered() -> void:
	if states.focus == 0 and !states.focussing:
		telephone_mesh.material_overlay.albedo_color.a = 1
		telephone_receiver_mesh.material_overlay.albedo_color.a = 1
func _on_telephone_area_mouse_exited() -> void:
	telephone_mesh.material_overlay.albedo_color.a = 0
	telephone_receiver_mesh.material_overlay.albedo_color.a = 0
#endregion
#region Telephone focus handling
var telephone_button_index: int = 0

func _on_telephone_keys_area_input_event(_camera: Node, _event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	var relative_position: Vector3 = (event_position - $"Desk Setup/TelephoneKeysArea/CollisionShape3D".global_position).rotated(Vector3.UP, deg_to_rad(-177.9))
	var size: Vector3 = $"Desk Setup/TelephoneKeysArea/CollisionShape3D".shape.size
	relative_position -= size / 2
	var index: int = clamp(floor((relative_position.x / size.x) * -3) + floor((relative_position.z / size.z) * -4) * 3, 0, 11)
	var button: MeshInstance3D = get_node("Desk Setup/Telephone/Telephone Base Bottom/Telephone Base Top/Button " + str(index))
	$"Desk Setup/Telephone/Telephone Base Bottom/Telephone Base Top/HoverSelect".position = button.position
	telephone_button_index = index

func _on_telephone_keys_area_mouse_entered() -> void:
	$"Desk Setup/Telephone/Telephone Base Bottom/Telephone Base Top/HoverSelect".mesh.surface_get_material(0).albedo_color.a = 1

func _on_telephone_keys_area_mouse_exited() -> void:
	$"Desk Setup/Telephone/Telephone Base Bottom/Telephone Base Top/HoverSelect".mesh.surface_get_material(0).albedo_color.a = 0

func _on_telephone_receiver_area_input_event(_camera: Node, _event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	pass # Replace with function body.

func _on_telephone_receiver_area_mouse_entered() -> void:
	telephone_receiver_mesh.material_overlay.albedo_color.a = 1

func _on_telephone_receiver_area_mouse_exited() -> void:
	telephone_receiver_mesh.material_overlay.albedo_color.a = 0
#endregion
#region Door Lock Material
func set_door_lock(locked: bool) -> void:
	var lock_material: StandardMaterial3D = $Door/LockStatus.mesh.surface_get_material(0)
	lock_material.albedo_color = Color(0.9, 0.225, 0.225, 1.0) if locked else Color("#39e639ff")
	lock_material.emission = lock_material.albedo_color
#endregion
#region Random Events
func roll_random_event() -> void:
	var roll: int = randi_range(0, time_random_events_pool.keys().back())
	print(roll)
	var key: int = roll
	while !time_random_events_pool.has(key):
		key+=1
	if time_random_events_pool[key] is Callable:
		time_random_events_pool[key].call()
	EventBus.schedule(self, "roll_random_event", time_random_events_interval)
func light_flicker() -> void:
	var child_index: int = randi_range(0, 3)
	var light_model: MeshInstance3D = $Lights.get_child(child_index).get_child(0)
	var light: OmniLight3D = $Lights.get_child(child_index + 4)
	var tween: Tween = create_tween()
	var set_override_material: Callable = func run():
		light_model.material_override = light_frame_material
	var del_override_material: Callable = func run():
		light_model.material_override = null
	light_model.material_override = light_frame_material
	light.visible = false
	tween.tween_interval(randf_range(0.025, 0.25))
	tween.tween_callback(del_override_material)
	tween.tween_property(light, "visible", true, 0)
	tween.tween_interval(randf_range(0.025, 0.25))
	tween.tween_callback(set_override_material)
	tween.tween_property(light, "visible", false, 0)
	tween.tween_interval(randf_range(0.025, 0.25))
	tween.tween_callback(del_override_material)
	tween.tween_property(light, "visible", true, 0)
	tween.play()
	Audio.play("light_flicker", Audio.light_flicker, -2.5, "SFX", light.global_position)
func knock_door() -> void:
	var door_position: Vector3 = Vector3(0, 1.25, 5 if randi_range(0, 1) == 0 else -5)
	Audio.play("door_knock", Audio.door_knock, -2.5, "SFX", door_position)
#endregion
#region Functions and Variables for CutsceneAnimator
@export
var alarm_volume: float:
	set(value):
		Audio.set_volume("alarm", value)
@export
var alarm0_volume: float:
	set(value):
		Audio.alarm.set_sync_stream_volume(0, value)
@export
var alarm1_volume: float:
	set(value):
		Audio.alarm.set_sync_stream_volume(1, value)
func set_alarm(playing: bool) -> void:
	if playing:
		Audio.play("alarm", Audio.alarm, -80, "SFX", Audio.MONITOR_POSITION)
	else:
		Audio.stop("alarm")
func set_security_breached(security_breached_visible: bool) -> void:
	states.monitor_scene.security_breached_visible = security_breached_visible
func set_eyelids(close: bool, eyelid_speed: float) -> void:
	EventBus.set_eyelids.emit(close, eyelid_speed)
func set_eyelids_instantly(close: bool) -> void:
	EventBus.set_eyelids_instantly.emit(close)
func set_subtitles(subtitle: String, stay_seconds: float, subtitle_show_time: float) -> void:
	EventBus.set_subtitles.emit(subtitle, stay_seconds, subtitle_show_time)
func remove_subtitles_instantly() -> void:
	EventBus.remove_subtitles_instantly.emit()
func music_fade_out(time: float) -> void:
	var fade_tween: Tween = create_tween()
	fade_tween.tween_method(func set_music_volume(volume: float): Audio.set_volume("music", volume), linear_to_db(0.4), -80, time)
	fade_tween.tween_callback(func stop_music(): Audio.stop("music"))
	fade_tween.play()
func fade_into_after_cutscene_music(time: float) -> void:
	Audio.stop("music")
	Audio.play("music", Audio.after_cutscene_music, -80, "Music", Vector3(), ProcessMode.PROCESS_MODE_ALWAYS)
	var fade_tween: Tween = create_tween()
	fade_tween.tween_method(func set_music_volume(volume: float): Audio.set_volume("music", volume), -80, linear_to_db(0.4), time)
	fade_tween.play()
#endregion
