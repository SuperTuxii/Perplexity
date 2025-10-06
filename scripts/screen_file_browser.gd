class_name ScreenFileBrowser extends ScreenPopup

signal pressed_file(path: String, type: String, data: Dictionary)

@onready
var folder_path_label: Label = $VBoxContainer/Content/VBoxContainer/HBoxContainer/FolderPathLabel
@onready
var back_button: Button = $VBoxContainer/Content/VBoxContainer/HBoxContainer/BackButton
@onready
var layout: GridContainer = $VBoxContainer/Content/VBoxContainer/ScrollContainer/GridContainer

var server_files: Dictionary = {
	"Server": {},
	"Server 1A": {
		"tutorial": {
			"type": "text",
			"size": "514B",
			"modified": "Today",
			"width": 400,
			"height": 400,
			"title": "Tutorial",
			"value": "In every hacked server you will find an \"unlock\" executable. [i]It is useful to run this first, so you know what you need to unlock the server (In this case it is a 4 digit code).[/i]\nTo find whatever is needed to unlock the server, you should investigate the files that can be found on this or previous servers. [i]The \"modified\" property for every file may hint at what files are important, but don't trust it too much![/i]\nIf you've got no clue what to do next, you may click the \"give me a hint\" executable to receive a hint (hints don't give you the answer directly and you will still need to use your brain)."
		},
		"unlock": {
			"type": "executable",
			"size": "1,2KB",
			"modified": "Today",
			"value": func run(_path: String, _data: Dictionary) -> ScreenPopup:
	return preload("res://scenes/monitor_scenes/file_executables/unlock_code.tscn").instantiate()
		},
		"give me a hint": {
			"type": "executable",
			"size": "923B",
			"modified": "Today",
			"title": "Hint",
			"value": func run(_path: String, _data: Dictionary) -> ScreenPopup:
	return preload("res://scenes/monitor_scenes/screen_popup.tscn").instantiate()
		},
		"code": {
			"type": "image",
			"size": "4,8KB",
			"modified": "Today",
			"title": "Code",
			"value": "res://assets/textures/server_1a/code.svg"
		},
		"reports": {
			"type": "folder",
			"size": "2 items",
			"modified": "Today",
			"value": {
				"report-88": {
					"type": "text",
					"size": "234B",
					"modified": "Last week",
					"width": 300,
					"height": 350,
					"value": "There is a creepy looking person in front of the company building! They suddenly came out of nowhere and told me: \"The square is the file size's last digit\". I have no idea what that is supposed to mean, but I am reporting this, because they looked like a security risk and so that we know this happened once already if this were to happen again."
				},
				"report-103": {
					"type": "image",
					"size": "12,8KB",
					"modified": "Today",
					"value": "res://assets/textures/server_1a/report-103.png"
				},
				"report-107": {
					"type": "text",
					"size": "134B",
					"modified": "Yesterday",
					"width": 300,
					"height": 350,
					"value": "The toilet on the south side of the second floor is clogged again. The janitor isn't available, so in the meantime don't try to flush that toilet under any circumstances! The reason probably is that the cleaning people keep emptying their buckets in the toilets even though they were told multiple times not to do that. Maybe someone should tell them again, but I doubt that it will help."
				}
			}
		}
		#"test_file": {
			#"type": "text",
			#"size": "7B",
			#"modified": "Today",
			#"value": "HEHEHE"
		#},
		#"test_executable": {
			#"type": "executable",
			#"size": "1,3KB",
			#"modified": "Today",
			#"value": func run(_path: String, _data: Dictionary) -> ScreenPopup:
	#return preload("res://scenes/monitor_scenes/screen_popup.tscn").instantiate()
		#},
		#"test_image": {
			#"type": "image",
			#"size": "449B",
			#"modified": "Today",
			#"value": "res://assets/textures/packets/normal_packet.png"
		#},
		#"test_folder": {
			#"type": "folder",
			#"size": "0 items",
			#"modified": "Today",
			#"value": {
				#"test_file2": {
					#"type": "text",
					#"size": "7B",
					#"modified": "Today",
					#"value": "HEHEHE 2"
				#}
			#}
		#}
	}
}:
	set(value):
		server_files = value
		update_contents()
var current_files: Dictionary

var root_folder_name: String = "":
	set(value):
		if server_files.has(value):
			root_folder_name = value
		else:
			root_folder_name = ""
			push_warning("Server with the root folder name \"" + value + "\" not found")
		update_contents()
var current_folder_path: String = "":
	set(value):
		current_folder_path = value
		update_contents()

func _ready() -> void:
	super._ready()
	update_contents()

func update_contents() -> void:
	visible = !root_folder_name.is_empty()
	if root_folder_name.is_empty():
		return
	folder_path_label.text = root_folder_name
	if !current_folder_path.is_empty():
		folder_path_label.text += " > " + current_folder_path.replace("/", " > ")
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
		return server_files[root_folder_name]
	var folders: PackedStringArray = current_folder_path.split("/", false)
	var files = server_files[root_folder_name]
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
	else:
		pressed_file.emit(root_folder_name + "/" + file_path, type, current_files[file_name])

func _on_back_button_pressed() -> void:
	if current_folder_path.contains("/"):
		current_folder_path = current_folder_path.substr(0, current_folder_path.rfind("/"))
	else:
		current_folder_path = ""
