class_name ScreenFileBrowser extends ScreenPopup

signal pressed_file(type: String, value: Variant)

@onready
var folder_path_label: Label = $VBoxContainer/Content/VBoxContainer/HBoxContainer/FolderPathLabel
@onready
var back_button: Button = $VBoxContainer/Content/VBoxContainer/HBoxContainer/BackButton
@onready
var layout: GridContainer = $VBoxContainer/Content/VBoxContainer/ScrollContainer/GridContainer

var structure: Dictionary = {
	"test_file": {
		"type": "text",
		"size": "7B",
		"modified": "Today",
		"value": "HEHEHE"
	},
	"test_executable": {
		"type": "executable",
		"size": "1,3KB",
		"modified": "Today",
		"value": func run(): print("I was just run!")
	},
	"test_image": {
		"type": "image",
		"size": "449B",
		"modified": "Today",
		"value": load("res://assets/textures/packets/normal_packet.png")
	},
	"test_folder": {
		"type": "folder",
		"size": "0 items",
		"modified": "Today",
		"value": {
			"test_file2": {
				"type": "text",
				"size": "7B",
				"modified": "Today",
				"value": "HEHEHE"
			}
		}
	}
}:
	set(value):
		structure = value
		update_contents()
var current_files: Dictionary

var root_folder_name: String = "Server"
var current_folder_path: String = "":
	set(value):
		current_folder_path = value
		update_contents()

func _ready() -> void:
	super._ready()
	update_contents()

func update_contents() -> void:
	folder_path_label.text = root_folder_name
	if !current_folder_path.is_empty():
		folder_path_label.text += " ► " + current_folder_path.replace("/", " ► ")
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
		name_button.pressed.connect(func run(): _on_file_pressed(file_name))
		layout.add_child(name_button)
		var size_button: Button = Button.new()
		size_button.text = current_files[file_name]["size"]
		size_button.disabled = true
		size_button.focus_mode = Control.FOCUS_NONE
		size_button.add_theme_color_override("font_disabled_color", name_button.get_theme_color("font_color"))
		size_button.add_theme_stylebox_override("disabled", name_button.get_theme_stylebox("normal"))
		layout.add_child(size_button)
		var modified_button: Button = Button.new()
		modified_button.text = current_files[file_name]["modified"]
		modified_button.disabled = true
		modified_button.focus_mode = Control.FOCUS_NONE
		modified_button.add_theme_color_override("font_disabled_color", name_button.get_theme_color("font_color"))
		modified_button.add_theme_stylebox_override("disabled", name_button.get_theme_stylebox("normal"))
		layout.add_child(modified_button)

func get_files_for_current_folder_path() -> Dictionary:
	if current_folder_path.is_empty():
		return structure
	var folders: PackedStringArray = current_folder_path.split("/", false)
	var files = structure
	for folder in folders:
		files = files[folder]["value"]
	return files

func _on_file_pressed(file_name: String) -> void:
	var type: String = current_files[file_name]["type"]
	if type == "folder":
		if current_folder_path.is_empty():
			current_folder_path = file_name
		else:
			current_folder_path += "/" + file_name
	else:
		pressed_file.emit(type, current_files[file_name]["value"])

func _on_back_button_pressed() -> void:
	if current_folder_path.contains("/"):
		current_folder_path = current_folder_path.substr(0, current_folder_path.rfind("/"))
	else:
		current_folder_path = ""
