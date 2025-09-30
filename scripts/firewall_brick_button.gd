class_name FirewallBrickButton extends Button

var port_number: int = -1:
	set(value):
		port_number = value
		$Label.visible = !disabled
		$Label.text = "Port " + str(port_number) + ": " + ("open" if button_pressed else "closed")

func _on_toggled(toggled_on: bool) -> void:
	$Label.text = "Port " + str(port_number) + ": " + ("open" if toggled_on else "closed")
