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
var focus: int = 0:
	set = set_focus

var head_fall_weight: float = -1

var mouse_motion: Vector2 = Vector2()
var mouse_pressed: bool = false
var mouse_movement: float = 0

func _ready() -> void:
	$ScreenOverlays.set_subtitles("I'm feeling a bit tire…", 2.5)
	$ScreenOverlays.eyes_move_weight = 0
	head_fall_weight = 0
	focus = -1

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
	if head_fall_weight != -1: # Head fall animation
		head_fall_weight += delta * 0.25
		head_fall_weight = minf(head_fall_weight, 1)
		camera.rotation = camera.rotation.lerp(Vector3(deg_to_rad(-60), 0, 0), head_fall_weight ** 4)
		if head_fall_weight == 1:
			camera.rotation = Vector3(deg_to_rad(-60), 0, 0)
			head_fall_weight = -1
			$Timer.start(1)

func set_focus(index: int) -> void:
	focus = index
	if index == -1:
		return # Other focus like a cutscene
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
		if !event.pressed and mouse_movement < 0.05:
			focus = 1
func _on_monitor_area_mouse_entered() -> void:
	if focus == 0 and focus_weight == -1:
		$"Desk Setup/Monitor/Monitor".material_overlay = outline_material
func _on_monitor_area_mouse_exited() -> void:
	$"Desk Setup/Monitor/Monitor".material_overlay = null

func _on_timer_timeout() -> void:
	if focus == -1 and $ScreenOverlays.eyes_position == 0:
		$ScreenOverlays.eyes_move_from = 0
		$ScreenOverlays.eyes_move_to = 2
		$ScreenOverlays.eyes_move_weight = 0
