class_name Main extends Node3D

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

var mouse_motion: Vector2 = Vector2()
var mouse_pressed: bool = false

func _process(_delta: float) -> void:
	mouse_motion.y = clamp(mouse_motion.y, -1.56 / drag_sensitivity, 1.56 / drag_sensitivity)
	$"Desk Setup/Chair/Camera".transform.basis = Basis.from_euler(Vector3(mouse_motion.y * -drag_sensitivity, 0, 0))
	$"Desk Setup/Chair".transform.basis = Basis.from_euler(Vector3(0, mouse_motion.x * -drag_sensitivity, 0))
	if Input.is_action_just_pressed("pause"):
		paused = !paused

func _input(event: InputEvent) -> void:
	if (!paused):
		# Screen dragging/panning
		if event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			mouse_pressed = event.pressed;
		if event is InputEventMouseMotion and mouse_pressed:
			mouse_motion += event.relative
		if event is InputEventScreenDrag:
			mouse_motion += event.screen_relative * 0.1
