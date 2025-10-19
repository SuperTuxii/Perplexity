class_name ScreenPopupStaff extends ScreenPopup

@export_multiline
var template: String = """[font_size=30]{name}[/font_size]

[b]Job Title:[/b] {job_title}
[b]Department:[/b] {department}
[b]Superior:[/b] {superior}
[b]Telephone:[/b] {telephone}

[b][u]Main Resonsibilities:[/u][/b]
{responsibilities}

[b][u]Qualifications:[/u][/b]
{qualifications}""":
	set(value):
		template = value
		update_information()

@export
var profile_color: Color = Color.WHITE:
	set(value):
		$VBoxContainer/Content/Button.add_theme_color_override("icon_disabled_color", value)
	get:
		return $VBoxContainer/Content/Button.get_theme_color("icon_disabled_color")

@export
var staff_name: String = "":
	set(value):
		staff_name = value
		update_information()
@export
var job_title: String = "":
	set(value):
		job_title = value
		update_information()
@export
var department: String = "":
	set(value):
		department = value
		update_information()
@export
var superior: String = "":
	set(value):
		superior = value
		update_information()
@export
var telephone: String = "":
	set(value):
		telephone = value
		update_information()

@export_multiline
var responsibilities: String = "":
	set(value):
		responsibilities = value
		update_information()
@export_multiline
var qualifications: String = "":
	set(value):
		qualifications = value
		update_information()

func _ready() -> void:
	super._ready()
	update_information()

func update_information() -> void:
	if template.is_empty() or !is_node_ready():
		return
	var text: String = template.replace("{name}", staff_name
	).replace("{job_title}", job_title
	).replace("{department}", department
	).replace("{superior}", superior
	).replace("{telephone}", telephone
	).replace("{responsibilities}", responsibilities
	).replace("{qualifications}", qualifications)
	$VBoxContainer/Content/RichTextLabel.text = text

static func apply_color_shader(color: Color) -> Color:
	color.s = 0.75
	color.v = 0.50
	color.a = 1
	return color
