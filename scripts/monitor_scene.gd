class_name MonitorScene extends Control

@export
var security_breached_visible: bool = false:
	set(value):
		$SecurityBreachedPanel.visible = value
		$LevelsScene.visible = !value
		if !value:
			$LevelsScene.mask_walk_time = 0
	get:
		return $SecurityBreachedPanel.visible
