class_name MonitorScene extends Control

var security_breached_visible: bool = false:
	set(value):
		$SecurityBreachedPanel.visible = value
		$LevelScreen.visible = !value
		if !value:
			mask_walk_time = 0
	get:
		return $SecurityBreachedPanel.visible

@export
var mask_walk_speed: float = 2
var mask_server_speed: float = 1
var mask_walk_time: float = -1
var mask_server_time: float = -1


func _process(delta: float) -> void:
	if mask_walk_time != -1: # Mask animation
		if mask_server_time != -1:
			mask_server_time += delta * mask_server_speed
			if mask_server_time > 1:
				mask_server_time = -1
		else:
			var prev_index: int = floori(mask_walk_time)
			mask_walk_time += delta * mask_walk_speed
			mask_walk_time = minf(mask_walk_time, $LevelScreen/ServerSprites.get_child_count()-1)
			var from_position: Vector2 = $LevelScreen/ServerSprites.get_child(floori(mask_walk_time)).position
			var to_position: Vector2 = $LevelScreen/ServerSprites.get_child(ceili(mask_walk_time)).position
			if prev_index != floori(mask_walk_time):
				mask_server_time = 0
				$LevelScreen/ServerSprites.get_child(floori(mask_walk_time)).hacked = true
				$LevelScreen/Mask.position = from_position
			else:
				$LevelScreen/Mask.position = from_position.lerp(to_position, fmod(mask_walk_time, 1) ** 1.35)
