class_name LevelsScene extends Node2D

@export
var mask_walk_speed: float = 2
var mask_server_speed: float = 1
var mask_walk_time: float = -1
var mask_server_time: float = -1

func _process(delta: float) -> void:
	# Mask animation
	if mask_server_time != -1:
		mask_server_time += delta * mask_server_speed
		if mask_server_time > 1:
			mask_server_time = -1
			$ServerSprites.get_child(floori(mask_walk_time) - 1).visible = false
			for child in $ServerSprites.get_child(floori(mask_walk_time)).get_children():
				child.visible = false
			$ServerLine.compute_line()
			$AudioPlayer.play()
			if mask_walk_time == -1:
				$Mask.visible = false
	elif mask_walk_time != -1:
		var prev_index: int = floori(mask_walk_time)
		mask_walk_time += delta * mask_walk_speed
		mask_walk_time = minf(mask_walk_time, $ServerSprites.get_child_count()-1)
		var from_position: Vector2 = $ServerSprites.get_child(floori(mask_walk_time)).position
		var to_position: Vector2 = $ServerSprites.get_child(ceili(mask_walk_time)).position
		if prev_index != floori(mask_walk_time):
			mask_server_time = 0
			$ServerSprites.get_child(floori(mask_walk_time)).hacked = true
			$Mask.position = from_position
		else:
			$Mask.position = from_position.lerp(to_position, fmod(mask_walk_time, 1) ** 1.35)
		if mask_walk_time == $ServerSprites.get_child_count()-1:
			mask_walk_time = -1
