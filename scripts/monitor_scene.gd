class_name MonitorScene extends ColorRect

@export
var popup_scene: PackedScene = preload("res://scenes/monitor_scenes/screen_popup.tscn")
@export
var popup_text_scene: PackedScene = preload("res://scenes/monitor_scenes/screen_popup_text.tscn")
@export
var popup_image_scene: PackedScene = preload("res://scenes/monitor_scenes/screen_popup_image.tscn")

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
		$LevelsScene.run_for_all_servers(func unlock_server(server: Server) -> void:
			server.pressable = true
		)

func finish_tutorial() -> void:
	tutorial_stage = -1
	for key in open_files:
		close_popup(open_files[key])
	$LevelsScene.run_for_all_servers(func lock_server(server: Server) -> void:
		server.pressable = false
	)

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
			popup = data["value"].call(path, data)
		popup.path = path
		if data.has("width") and data.has("height"):
			popup.size = Vector2(data["width"], data["height"])
		if data.has("title"):
			popup.title = data["title"]
		popup.position = (size / 2) - (popup.size / 2)
		popup.focus.connect(focus_popup)
		popup.close.connect(close_popup)
		add_child(popup)
		open_files[path] = popup
	focus_popup(open_files[path])

func _on_levels_scene_mask_walk_finished() -> void:
	EventBus.schedule($IntroPopupInformation, "show", 1.5)

func _on_levels_scene_open_server_files(root_folder_name: String) -> void:
	if tutorial_stage == 0:
		$ClickServerTutorial.visible = false
		$ScreenFileBrowser/FileTutorial.visible = true
		$ScreenFileBrowser.pressed_file.connect(_on_file_browser_file_pressed)
		tutorial_stage = 1
	if tutorial_stage >= 0:
		root_folder_name = "Server"
	if $ScreenFileBrowser.root_folder_name == root_folder_name:
		$ScreenFileBrowser.visible = !$ScreenFileBrowser.visible
	else:
		$ScreenFileBrowser.root_folder_name = root_folder_name

# Tutorial signal handlers
func _on_file_browser_file_pressed(path: String, _type: String, _data: Dictionary) -> void:
	if path == "Server/unlock":
		$ScreenFileBrowser/FileTutorial.visible = false
		$ScreenFileBrowser.pressed_file.disconnect(_on_file_browser_file_pressed)
		$UnlockCodeTutorial.visible = true
		open_files["Server/unlock"].close.connect(_on_unlock_code_close)
		tutorial_stage = 2
func _on_unlock_code_close(popup: ScreenPopup) -> void:
	$UnlockCodeTutorial.visible = false
	popup.close.disconnect(_on_unlock_code_close)
	$SearchFilesTutorial.visible = true
	$ScreenFileBrowser.pressed_folder.connect(_on_file_browser_folder_pressed)
	tutorial_stage = 3
func _on_file_browser_folder_pressed() -> void:
	$SearchFilesTutorial.visible = false
	$ScreenFileBrowser.pressed_folder.disconnect(_on_file_browser_folder_pressed)
	$ScreenFileBrowser/BackTutorial.visible = true
	$ScreenFileBrowser.pressed_back.connect(_on_file_browser_back_pressed)
	tutorial_stage = 4
func _on_file_browser_back_pressed() -> void:
	$ScreenFileBrowser/BackTutorial.visible = false
	$ScreenFileBrowser.pressed_back.disconnect(_on_file_browser_back_pressed)
	tutorial_stage = 5

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		EventBus.play_mouse_sound.emit(event.pressed, -20)
