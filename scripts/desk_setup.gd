class_name DeskSetup extends Node3D

var mouse_motion: Vector2 = Vector2()
var mouse_pressed: bool = false

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(_delta: float) -> void:
	mouse_motion.y = clamp(mouse_motion.y, -1560, 1560)
	$Chair/Camera.transform.basis = Basis.from_euler(Vector3(mouse_motion.y * -0.001, 0, 0))
	$Chair.transform.basis = Basis.from_euler(Vector3(0, mouse_motion.x * -0.001, 0))
	if Input.is_action_just_pressed("pause"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	#For Click and Move Action
	#if event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
		#mouse_pressed = event.pressed;
	#if event is InputEventMouseMotion and mouse_pressed:
		#mouse_motion += event.relative
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		mouse_motion += event.relative
