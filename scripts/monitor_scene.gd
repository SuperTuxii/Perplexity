class_name MonitorScene extends Control

var security_breached_visible: bool = false:
	set(value):
		$Background/SecurityBreachedPanel.visible = value
	get:
		return $Background/SecurityBreachedPanel.visible
