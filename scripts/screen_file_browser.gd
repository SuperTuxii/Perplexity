class_name ScreenFileBrowser extends ScreenPopup

signal pressed_file(path: String, type: String, data: Dictionary)
signal pressed_folder
signal pressed_back

@onready
var folder_path_label: Label = $VBoxContainer/Content/VBoxContainer/HBoxContainer/FolderPathLabel
@onready
var back_button: Button = $VBoxContainer/Content/VBoxContainer/HBoxContainer/BackButton
@onready
var layout: GridContainer = $VBoxContainer/Content/VBoxContainer/ScrollContainer/GridContainer

@export
var button_theme: Theme = preload("res://theme/file_manager_table_theme.tres")

var current_files: Dictionary

var root_folder_name: String = "":
	set(value):
		if Config.server_files.has(value):
			root_folder_name = value
		else:
			root_folder_name = ""
			push_warning("Server with the root folder name \"" + value + "\" not found")
		current_folder_path = ""
		update_contents()
var current_folder_path: String = "":
	set(value):
		current_folder_path = value
		update_contents()

var is_mouse_inside_content: bool = false

func _ready() -> void:
	super._ready()
	update_contents()
	Config.server_files_changed.connect(update_contents)

func update_contents() -> void:
	visible = !root_folder_name.is_empty()
	if root_folder_name.is_empty():
		return
	folder_path_label.text = tr(root_folder_name)
	if !current_folder_path.is_empty():
		var path_folders: PackedStringArray = current_folder_path.split("/")
		for folder in path_folders:
			folder_path_label.text += " > " + tr(folder)
	back_button.disabled = current_folder_path.is_empty()
	for child in layout.get_children():
		if child is Button:
			child.queue_free()
	current_files = get_files_for_current_folder_path()
	for file_name in current_files:
		var name_button: Button = Button.new()
		name_button.text = file_name
		name_button.icon = load("res://assets/textures/file_types/" + current_files[file_name]["type"] + ".svg")
		name_button.focus_mode = Control.FOCUS_NONE
		name_button.theme = button_theme
		name_button.pressed.connect(func run(): _on_file_pressed(file_name))
		name_button.mouse_entered.connect(_on_content_mouse_entered)
		name_button.mouse_exited.connect(_on_content_mouse_exited)
		layout.add_child(name_button)
		var size_button: Button = Button.new()
		size_button.text = current_files[file_name]["size"]
		size_button.disabled = true
		size_button.focus_mode = Control.FOCUS_NONE
		size_button.theme = button_theme
		size_button.mouse_entered.connect(_on_content_mouse_entered)
		size_button.mouse_exited.connect(_on_content_mouse_exited)
		layout.add_child(size_button)
		var modified_button: Button = Button.new()
		modified_button.text = current_files[file_name]["modified"]
		modified_button.disabled = true
		modified_button.focus_mode = Control.FOCUS_NONE
		modified_button.theme = button_theme
		modified_button.mouse_entered.connect(_on_content_mouse_entered)
		modified_button.mouse_exited.connect(_on_content_mouse_exited)
		layout.add_child(modified_button)

func get_files_for_current_folder_path() -> Dictionary:
	if current_folder_path.is_empty():
		return Config.server_files[root_folder_name]
	var folders: PackedStringArray = current_folder_path.split("/", false)
	var files = Config.server_files[root_folder_name]
	for folder in folders:
		files = files[folder]["value"]
	return files

func _on_file_pressed(file_name: String) -> void:
	var type: String = current_files[file_name]["type"]
	var file_path = current_folder_path
	if file_path.is_empty():
		file_path = file_name
	else:
		file_path += "/" + file_name
	if type == "folder":
		current_folder_path = file_path
		pressed_folder.emit()
	else:
		pressed_file.emit(root_folder_name + "/" + file_path, type, current_files[file_name])

func _on_back_button_pressed() -> void:
	if current_folder_path.contains("/"):
		current_folder_path = current_folder_path.substr(0, current_folder_path.rfind("/"))
	else:
		current_folder_path = ""
	pressed_back.emit()

func _on_content_mouse_entered() -> void:
	is_mouse_inside_content = true
func _on_content_mouse_exited() -> void:
	is_mouse_inside_content = false
