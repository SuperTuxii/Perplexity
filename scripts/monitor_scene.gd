class_name MonitorScene extends ColorRect

@export
var security_breached_visible: bool = false:
	set(value):
		$SecurityBreachedPanel.visible = value
		$LevelsScene.visible = !value
		if !value:
			$LevelsScene.mask_walk_time = 0
		else:
			color = Color("301111ff")
	get:
		return $SecurityBreachedPanel.visible

var focused_popup: ScreenPopup

func _ready() -> void:
	for child in get_children():
		if child is ScreenPopup:
			child.focus.connect(focus_popup)

func focus_popup(popup: ScreenPopup) -> void:
	if focused_popup:
		focused_popup.z_index = 0
	popup.z_index = 1
	focused_popup = popup

func _on_file_browser_pressed_file(type: String, _value: Variant) -> void:
	if type == "text":
		pass
	elif type == "image":
		pass
	elif type == "executable":
		pass
