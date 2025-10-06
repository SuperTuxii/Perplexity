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

var tutorial_stage: int = -1

var focused_popup: ScreenPopup
var open_files: Dictionary = {}

func start_tutorial() -> void:
	if tutorial_stage == -1:
		tutorial_stage = 0
		$ClickServerTutorial.visible = true

func focus_popup(popup: ScreenPopup) -> void:
	if focused_popup:
		focused_popup.z_index = 0
	popup.z_index = 1
	focused_popup = popup

func close_popup(popup: ScreenPopup) -> void:
	if !popup.path.is_empty() and open_files.has(popup.path):
		open_files.erase(popup.path)
	popup.queue_free()

func _on_file_browser_pressed_file(path: String, type: String, data: Dictionary) -> void:
	if !open_files.has(path):
		var popup: ScreenPopup
		if type == "text":
			popup = popup_text_scene.instantiate()
			popup.text = data["value"]
		elif type == "image":
			popup = popup_image_scene.instantiate()
			popup.image = load(data["value"])
		elif type == "executable":
			popup = popup_scene.instantiate()
			popup.path = path
			data["value"].call(popup)
		popup.path = path
		if data.has("width") and data.has("height"):
			popup.custom_minimum_size = Vector2(data["width"], data["height"])
		popup.position = (size / 2) - (popup.size / 2)
		popup.focus.connect(focus_popup)
		popup.close.connect(close_popup)
		add_child(popup)
		open_files[path] = popup
	focus_popup(open_files[path])

func _on_levels_scene_mask_walk_finished() -> void:
	EventBus.schedule($IntroPopupInformation, "show", 1.5)
	EventBus.schedule(self, "start_tutorial", 4)

func _on_levels_scene_open_server_files(root_folder_name: String) -> void:
	if tutorial_stage <= 0:
		$ClickServerTutorial.queue_free()
		$ScreenFileBrowser/FileBrowserTutorial.visible = true
		EventBus.schedule(self, "_on_screen_file_browser_close", 7.5)
		tutorial_stage = 1
	if $ScreenFileBrowser.root_folder_name == root_folder_name:
		$ScreenFileBrowser.visible = !$ScreenFileBrowser.visible
	else:
		$ScreenFileBrowser.root_folder_name = root_folder_name

func _on_screen_file_browser_close(_popup: ScreenPopup = null) -> void:
	if tutorial_stage == 1:
		$ScreenFileBrowser/FileBrowserTutorial.queue_free()
		tutorial_stage = 2
