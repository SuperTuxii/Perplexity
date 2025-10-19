class_name MonitorScene extends ColorRect

@onready
var file_browser: ScreenFileBrowser = $ScreenFileBrowser
@onready
var levels_scene: LevelsScene = $LevelsScene

@export
var popup_scene: PackedScene = preload("res://scenes/monitor_scenes/screen_popup.tscn")
@export
var popup_text_scene: PackedScene = preload("res://scenes/monitor_scenes/screen_popup_text.tscn")
@export
var popup_image_scene: PackedScene = preload("res://scenes/monitor_scenes/screen_popup_image.tscn")
@export
var popup_staff_scene: PackedScene = preload("res://scenes/monitor_scenes/screen_popup_staff.tscn")

var security_breached_visible: bool = false:
	set(value):
		$SecurityBreachedPanel.visible = value
		levels_scene.visible = !value
		if !value:
			levels_scene.mask_walk_time = 0
		else:
			color = Color("301111ff")
	get:
		return $SecurityBreachedPanel.visible

var tutorial_stage: int = -1

var focused_popup: ScreenPopup
var open_files: Dictionary = {}

func _ready() -> void:
	EventBus.called_number.connect(_on_called_number)

func start_tutorial() -> void:
	if tutorial_stage == -1:
		tutorial_stage = 0
		$ClickServerTutorial.visible = true
		levels_scene.run_for_all_servers(func unlock_server(server: Server) -> void:
			server.pressable = true
		)

func finish_tutorial() -> void:
	tutorial_stage = -1
	for key in open_files:
		close_popup(open_files[key])
	levels_scene.run_for_all_servers(func lock_server(server: Server) -> void:
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
		elif type == "staff":
			popup = popup_staff_scene.instantiate()
			if data.has("profile_color"):
				popup.profile_color = data["profile_color"]
			popup.staff_name = data["name"]
			popup.job_title = data["job_title"]
			popup.department = data["department"]
			popup.superior = data["superior"]
			popup.telephone = data["telephone"]
			popup.responsibilities = data["responsibilities"]
			popup.qualifications = data["qualifications"]
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
	EventBus.schedule($IntroPopupInformation.show, 1.5)

func _on_levels_scene_open_server_files(root_folder_name: String) -> void:
	if tutorial_stage == 0:
		$ClickServerTutorial.visible = false
		$ScreenFileBrowser/FileTutorial.visible = true
		file_browser.pressed_file.connect(_on_file_browser_file_pressed)
		tutorial_stage = 1
	if tutorial_stage >= 0:
		root_folder_name = "Server"
	if file_browser.root_folder_name == root_folder_name:
		file_browser.visible = !file_browser.visible
	else:
		file_browser.root_folder_name = root_folder_name

func _on_called_number(number: String) -> void:
	if levels_scene.unlocked_servers.has("Server 1A") and !levels_scene.unlocked_servers.has("Server 2A"):
		if Config.telephone_actions["Server 2A"].has(number):
			var actions: Array = Config.telephone_actions["Server 2A"][number]
			for action in actions:
				if action.scope == -1:
					for i in range(Config.server_files["Server 2A"]["unlock"]["current_shapes"].size()):
						UnlockSymbolCombination.apply_action(Config.server_files["Server 2A"]["unlock"], i, action)
				else:
					UnlockSymbolCombination.apply_action(Config.server_files["Server 2A"]["unlock"], action.scope, action)
			EventBus.updated_lvl2_unlock.emit()
			EventBus.schedule(Audio.play, 5, "number_accepted", Audio.telephone_pickup, 0, "SFX", Audio.TELEPHONE_POSITION)

# Tutorial signal handlers
func _on_file_browser_file_pressed(path: String, _type: String, _data: Dictionary) -> void:
	if path == "Server/unlock":
		$ScreenFileBrowser/FileTutorial.visible = false
		file_browser.pressed_file.disconnect(_on_file_browser_file_pressed)
		$UnlockCodeTutorial.visible = true
		open_files["Server/unlock"].close.connect(_on_unlock_code_close)
		tutorial_stage = 2
func _on_unlock_code_close(popup: ScreenPopup) -> void:
	$UnlockCodeTutorial.visible = false
	popup.close.disconnect(_on_unlock_code_close)
	$SearchFilesTutorial.visible = true
	file_browser.pressed_folder.connect(_on_file_browser_folder_pressed)
	tutorial_stage = 3
func _on_file_browser_folder_pressed() -> void:
	$SearchFilesTutorial.visible = false
	file_browser.pressed_folder.disconnect(_on_file_browser_folder_pressed)
	$ScreenFileBrowser/BackTutorial.visible = true
	file_browser.pressed_back.connect(_on_file_browser_back_pressed)
	tutorial_stage = 4
func _on_file_browser_back_pressed() -> void:
	$ScreenFileBrowser/BackTutorial.visible = false
	file_browser.pressed_back.disconnect(_on_file_browser_back_pressed)
	tutorial_stage = 5

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		Audio.play("mouse", Audio.mouse_click_press if event.pressed else Audio.mouse_click_release, -20, "SFX", Audio.MOUSE_POSITION)
