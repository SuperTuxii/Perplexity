class_name MonitorScene extends ColorRect

@export
var popup_scene: PackedScene = preload("res://scenes/monitor_scenes/screen_popup.tscn")
@export
var popup_text_scene: PackedScene = preload("res://scenes/monitor_scenes/screen_popup_text.tscn")
@export
var popup_image_scene: PackedScene = preload("res://scenes/monitor_scenes/screen_popup_image.tscn")

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
var open_files: Dictionary = {}

func focus_popup(popup: ScreenPopup) -> void:
	if focused_popup:
		focused_popup.z_index = 0
	popup.z_index = 1
	focused_popup = popup

func close_popup(popup: ScreenPopup) -> void:
	if !popup.path.is_empty() and open_files.has(popup.path):
		open_files.erase(popup.path)
	popup.queue_free()

func _on_file_browser_pressed_file(path: String, type: String, value: Variant) -> void:
	if !open_files.has(path):
		var popup
		if type == "text":
			popup = popup_text_scene.instantiate()
			popup.text = value
		elif type == "image":
			popup = popup_image_scene.instantiate()
			popup.image = load(value)
		elif type == "executable":
			popup = popup_scene.instantiate()
			value.call(path, popup)
		popup.path = path
		popup.position = (size / 2) - (popup.size / 2)
		popup.focus.connect(focus_popup)
		popup.close.connect(close_popup)
		add_child(popup)
		open_files[path] = popup
	focus_popup(open_files[path])

func _on_levels_scene_open_server_files(root_folder_name: String) -> void:
	$ScreenFileBrowser.root_folder_name = root_folder_name
