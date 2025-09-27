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
var mouse_press_position: Vector2 = Vector2()

func _process(_delta: float) -> void:
	mouse_motion.y = clamp(mouse_motion.y, -1.56, 1.56)
	$"Desk Setup/Chair/Camera".transform.basis = Basis.from_euler(Vector3(mouse_motion.y, 0, 0))
	$"Desk Setup/Chair".transform.basis = Basis.from_euler(Vector3(0, mouse_motion.x, 0))
	if Input.is_action_just_pressed("pause"):
		paused = !paused

func _input(event: InputEvent) -> void:
	if (!paused):
		# Screen dragging/panning
		if (event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT) or event is InputEventScreenTouch:
			mouse_pressed = event.pressed
			if event.pressed:
				mouse_press_position = mouse_motion
			else:
				if abs(mouse_press_position - mouse_motion).length() < 0.05:
					pass #check for interact with object
		if (event is InputEventMouseMotion and mouse_pressed) or event is InputEventScreenDrag:
			mouse_motion += event.relative * -drag_sensitivity
