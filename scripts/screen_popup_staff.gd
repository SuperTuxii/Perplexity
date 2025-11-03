class_name ScreenPopupStaff extends ScreenPopup

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

@export
var responsibilities: Array = []:
	set(value):
		responsibilities = value
		update_information()
@export
var qualifications: Array = []:
	set(value):
		qualifications = value
		update_information()

func _ready() -> void:
	super._ready()
	update_information()
	EventBus.language_changed.connect(update_information)

func update_information() -> void:
	if !is_node_ready():
		return
	var text: String = ""
	text += "[font_size=30]" + tr(staff_name) + "[/font_size]\n\n"
	text += "[b]" + tr("Job Title") + ":[/b] " + tr(job_title) + "\n"
	text += "[b]" + tr("Department") + ":[/b] " + tr(department) + "\n"
	text += "[b]" + tr("Superior") + ":[/b] " + tr(superior) + "\n"
	text += "[b]" + tr("Telephone") + ":[/b] " + telephone + "\n\n"
	text += "[b][u]" + tr("Main Resonsibilities") + ":[/u][/b]\n"
	for responsibility in responsibilities:
		text += responsibility.point + " "
		if responsibility.has("color"):
			text += "[color=" + responsibility.color.to_html() + "]" + tr(responsibility.content) + "[/color]\n"
		else:
			text += tr(responsibility.content) + "\n"
	text += "[b][u]" + tr("Qualifications") + ":[/u][/b]\n"
	for qualification in qualifications:
		text += qualification.point + " "
		if qualification.has("color"):
			text += "[color=" + qualification.color.to_html() + "]" + tr(qualification.content) + "[/color]\n"
		else:
			text += tr(qualification.content) + "\n"
	$VBoxContainer/Content/RichTextLabel.text = text

static func apply_color_shader(color: Color) -> Color:
	color.s = 0.75
	color.v = 0.50
	color.a = 1
	return color
