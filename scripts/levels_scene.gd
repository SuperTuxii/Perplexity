class_name LevelsScene extends Node2D

@export
var mask_server_hack_sound: AudioStream
@export
var mask_final_server_hack_sound: AudioStream
@export
var mask_server_start_hack_sound: AudioStream
@export
var mask_final_server_start_hack_sound: AudioStream
@export
var mask_walk_speed: float = 2
var mask_server_speed: float = 0.4
var mask_walk_time: float = -1:
	set(value):
		mask_walk_time = value
		if value == 0:
			EventBus.set_skip_button.emit(true)
			EventBus.skipped.connect(skip_mask_walk)
			EventBus.finished_focus_change.connect(finished_focus_change)
		elif value == -1:
			EventBus.set_skip_button.emit(false)
			EventBus.skipped.disconnect(skip_mask_walk)
			EventBus.finished_focus_change.disconnect(finished_focus_change)
var mask_server_time: float = -1

func _process(delta: float) -> void:
	# Mask animation
	if mask_server_time != -1:
		mask_server_time += delta * mask_server_speed
		if mask_server_time > 1:
			mask_server_time = -1
			$ServerSprites.get_child(floori(mask_walk_time) - 1).visible = false
			for child in $ServerSprites.get_child(floori(mask_walk_time)).get_children():
				if child is Server:
					child.visible = false
			$ServerLine.compute_line()
			if mask_walk_time == -1:
				$Mask.visible = false
				$ServerSprites.get_child(floori(mask_walk_time)).pressable = true
				EventBus.play_monitor_sound.emit(mask_final_server_hack_sound, -30)
			else:
				EventBus.play_monitor_sound.emit(mask_server_hack_sound, -32.5)
	elif mask_walk_time != -1:
		var prev_index: int = floori(mask_walk_time)
		mask_walk_time += delta * mask_walk_speed
		mask_walk_time = minf(mask_walk_time, $ServerSprites.get_child_count()-1)
		var from_position: Vector2 = $ServerSprites.get_child(floori(mask_walk_time)).position
		var to_position: Vector2 = $ServerSprites.get_child(ceili(mask_walk_time)).position
		if prev_index != floori(mask_walk_time):
			mask_server_time = 0
			if mask_walk_time == $ServerSprites.get_child_count()-1:
				EventBus.play_monitor_sound.emit(mask_final_server_start_hack_sound, -32.5)
			else:
				EventBus.play_monitor_sound.emit(mask_server_start_hack_sound, -36)
			$ServerSprites.get_child(floori(mask_walk_time)).hacked = true
			$Mask.position = from_position
		else:
			$Mask.position = from_position.lerp(to_position, fmod(mask_walk_time, 1) ** 1.35)
		if mask_walk_time == $ServerSprites.get_child_count()-1:
			mask_walk_time = -1

func skip_mask_walk() -> void:
	mask_walk_time = -1
	mask_server_time = -1
	for i in range($ServerSprites.get_child_count() - 1):
		var child = $ServerSprites.get_child(i)
		if child is Server:
			child.visible = false
			child.hacked = true
	$ServerLine.compute_line()
	EventBus.play_monitor_sound.emit(mask_final_server_hack_sound, -30)
	$Mask.visible = false
	var last_child = $ServerSprites.get_child($ServerSprites.get_child_count() - 1)
	last_child.pressable = true
	last_child.hacked = true

func finished_focus_change(focus: int) -> void:
	if focus == 1:
		EventBus.set_skip_button.emit(true)
