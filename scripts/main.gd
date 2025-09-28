class_name Main extends Node3D

@export
var outline_material: Material = preload("res://materials/OutlineMaterial.tres")

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
var mouse_movement: float = 0

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
				mouse_movement = 0
		if (event is InputEventMouseMotion and mouse_pressed) or event is InputEventScreenDrag:
			mouse_motion += event.relative * -drag_sensitivity
			mouse_movement += (event.relative * drag_sensitivity).length()

func _on_monitor_area_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if (event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT) or event is InputEventScreenTouch:
		if !event.pressed and mouse_movement < 0.05:
			pass
			#print("Interacted with Monitor!")

func _on_monitor_area_mouse_entered() -> void:
	$"Desk Setup/Monitor/Monitor".material_overlay = outline_material

func _on_monitor_area_mouse_exited() -> void:
	$"Desk Setup/Monitor/Monitor".material_overlay = null
