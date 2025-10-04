class_name ScreenFileBrowser extends ScreenPopup

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
		"value": {}
	}
}:
	set(value):
		structure = value
		update_contents()

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
	var current_files = structure # TODO: rework this to work with "current_folder_path"
	for file_name in current_files:
		var name_button: Button = Button.new()
		name_button.text = file_name
		name_button.icon = load("res://assets/textures/packets/normal_packet.png")
		name_button.focus_mode = Control.FOCUS_NONE
		layout.add_child(name_button)
		var size_button: Button = Button.new()
		size_button.text = current_files[file_name]["size"]
		size_button.focus_mode = Control.FOCUS_NONE
		layout.add_child(size_button)
		var modified_button: Button = Button.new()
		modified_button.text = current_files[file_name]["modified"]
		modified_button.focus_mode = Control.FOCUS_NONE
		layout.add_child(modified_button)

func _on_back_button_pressed() -> void:
	if current_folder_path.contains("/"):
		current_folder_path = current_folder_path.substr(0, current_folder_path.rfind("/"))
	else:
		current_folder_path = ""
