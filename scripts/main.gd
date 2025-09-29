class_name Main extends Node3D

@export
var outline_material: Material = preload("res://materials/OutlineMaterial.tres")
@onready
var camera: Camera3D = $"Desk Setup/Chair/Camera"

var paused: bool:
	get:
		return $PauseMenu.visible
	set(value):
		$PauseMenu.visible = value
var drag_sensitivity: float:
	get:
		return $PauseMenu.drag_sensitivity
	set(value):
		$PauseMenu.drag_sensitivity = value

@export
var focus_speed: float = 2.5
var focus_weight: float = -1
var focus_from_position: Vector3 = Vector3()
var focus_from_rotation: Vector3 = Vector3()
var focus_to_position: Vector3 = Vector3()
var focus_to_rotation: Vector3 = Vector3()
var focus: int = -1:
	set = set_focus

var head_fall_weight: float = -1

var mouse_motion: Vector2 = Vector2()
var mouse_pressed: bool = false
var mouse_movement: float = 0

func _ready() -> void:
	$CutsceneAnimator.play("start_sleep")
	$ScreenOverlays.set_skip_button(true)
	$ScreenOverlays.skipped.connect(skip_cutscene)

func _process(delta: float) -> void:
	if focus == 0 and focus_weight == -1: # Applying screen drag when focus is 0
		mouse_motion.y = clamp(mouse_motion.y, -1.56, 1.56)
		camera.transform.basis = Basis.from_euler(Vector3(mouse_motion.y, 0, 0))
		$"Desk Setup/Chair".transform.basis = Basis.from_euler(Vector3(0, mouse_motion.x, 0))
	if Input.is_action_just_pressed("pause"): # Pause menu and exiting focus
		if focus == 0:
			paused = !paused
		else:
			focus = 0
	if focus_weight != -1: # Focus animation
		focus_weight += delta * focus_speed
		focus_weight = minf(focus_weight, 1)
		camera.position = focus_from_position.slerp(focus_to_position, focus_weight)
		camera.rotation = focus_from_rotation.slerp(focus_to_rotation * (PI / 180), focus_weight)
		if focus_weight == 1:
			camera.position = focus_to_position
			camera.rotation = focus_to_rotation * (PI / 180)
			focus_weight = -1
			finished_focus()

func set_focus(index: int) -> void:
	focus = index
	if index == -1:
		return # Other focus like a cutscene
	$ScreenOverlays.set_skip_button(false)
	# Focus animation configuration
	match index:
		0: # No focus/on chair
			mouse_motion.y = 0
			camera.reparent($"Desk Setup/Chair")
			focus_to_position = Vector3(0, 1.2, 0)
			focus_to_rotation = Vector3()
		1: # Monitor focused
			$"Desk Setup/Monitor/Monitor".material_overlay = null
			camera.reparent($"Desk Setup/Monitor")
			focus_to_position = Vector3(0.3, 0.34, 0)
			focus_to_rotation = Vector3(0, 90, 0)
	focus_from_position = camera.position
	focus_from_rotation = camera.rotation
	focus_weight = 0

func finished_focus() -> void:
	# Actions when focus animation finishes
	match focus:
		1:
			if $MonitorViewport/MonitorScene.security_breached_visible:
				$MonitorViewport/MonitorScene.security_breached_visible = false
				$CutsceneAnimator.play("alarm_ease_out")
	$"Desk Setup/MonitorArea".visible = focus == 0
	$"Desk Setup/ScreenArea".visible = focus == 1

func skip_cutscene() -> void:
	$ScreenOverlays.set_skip_button(false)
	$ScreenOverlays.skipped.disconnect(skip_cutscene)
	$CutsceneAnimator.play("skip_" + $CutsceneAnimator.current_animation)
	camera.rotation.x = 0

func _input(event: InputEvent) -> void:
	if !paused and focus == 0 and focus_weight == -1: # Saving screen drag when focus is 0
		if event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			mouse_pressed = event.pressed
			if event.pressed:
				mouse_movement = 0
		if event is InputEventMouseMotion and mouse_pressed:
			mouse_motion += event.relative * -drag_sensitivity
			mouse_movement += (event.relative * drag_sensitivity).length()

# Monitor hover and focus
func _on_monitor_area_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
		if !event.pressed and focus == 0 and mouse_movement < 0.05:
			focus = 1
func _on_monitor_area_mouse_entered() -> void:
	if focus == 0 and focus_weight == -1:
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
func _on_screen_area_input_event(_camera: Node, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
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
