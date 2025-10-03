class_name MonitorScene extends ColorRect

@export
var security_breached_visible: bool = false:
	set(value):
		$SecurityBreachedPanel.visible = value
		$LevelsScene.visible = !value
		if !value:
			$LevelsScene.mask_walk_time = 0
		else:
			color = Color("301111ff")
	get:
		return $SecurityBreachedPanel.visible
