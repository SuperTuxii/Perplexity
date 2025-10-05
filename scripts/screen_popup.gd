class_name ScreenPopup extends PanelContainer

signal focus(popup: ScreenPopup)
signal close(popup: ScreenPopup)

@export
var title: String:
	set(value):
		$VBoxContainer/Top/TitleLabel.text = value
	get:
		return $VBoxContainer/Top/TitleLabel.text
var path: String = ""

var show_tween: Tween
var mouse_pressed: bool = false
var mouse_position: Vector2 = Vector2()

func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)

func _on_visibility_changed() -> void:
	if visible:
		if show_tween:
			show_tween.kill()
		show_tween = create_tween()
		show_tween.set_parallel(true)
		show_tween.tween_property(self, "global_position", global_position, 0.1)
		show_tween.tween_property(self, "scale", Vector2(1, 1), 0.1)
		global_position = Vector2(0, get_viewport_rect().size.y)
		scale = Vector2()
		show_tween.play()
	else:
		close.emit(self)

func _on_title_label_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		focus.emit(self)
		if event.button_index == MOUSE_BUTTON_LEFT:
			mouse_pressed = event.pressed
			mouse_position = position
	elif event is InputEventMouseMotion and mouse_pressed:
		mouse_position += event.relative
		position.x = clamp(mouse_position.x, 0, get_viewport_rect().size.x - size.x)
		position.y = clamp(mouse_position.y, 0, get_viewport_rect().size.y - size.y)

func _on_close_button_pressed() -> void:
	visible = false

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		focus.emit(self)
