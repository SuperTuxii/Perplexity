class_name FirewallBrickButton extends Button

@export
var open_label_settings: LabelSettings
@export
var closed_label_settings: LabelSettings

var port_number: int = -1:
	set(value):
		port_number = value
		$Label.visible = !disabled
		$Path.visible = !disabled
		_on_toggled(button_pressed)

func _on_toggled(toggled_on: bool) -> void:
	$Label.text = "Port " + str(port_number) + ": " + ("open" if toggled_on else "closed")
	$Label.label_settings = open_label_settings if toggled_on else closed_label_settings
