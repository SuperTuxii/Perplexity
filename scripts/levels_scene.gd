class_name LevelsScene extends Node2D

signal open_server_files(root_folder_name: String)
signal mask_walk_finished

@export
var mask_server_hack_sound: AudioStream
@export
var mask_final_server_hack_sound: AudioStream
@export
var mask_server_start_hack_sound: AudioStream
@export
var mask_final_server_start_hack_sound: AudioStream
@export
var server_unlock_sound: AudioStream
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

func _ready() -> void:
	run_for_all_servers(func init_server(server: Server) -> void:
		server.pressed.connect(func run(): open_server_files.emit(server.root_folder_name))
	)
	EventBus.unlock_server.connect(unlock_server)

func run_for_all_servers(function: Callable) -> void:
	run_for_all_servers_recursive($ServerSprites, function)

func run_for_all_servers_recursive(object: Node2D, function: Callable) -> void:
	for child in object.get_children():
		if child is Server:
			function.call(child)
			run_for_all_servers_recursive(child, function)

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
				mask_walk_finished.emit()
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
			for child_child in child.get_children():
				if child_child is Server:
					child_child.visible = false
	$ServerLine.compute_line()
	EventBus.play_monitor_sound.emit(mask_final_server_hack_sound, -30) #Sample not supported?!?!
	$Mask.visible = false
	var last_child = $ServerSprites.get_child($ServerSprites.get_child_count() - 1)
	last_child.pressable = true
	last_child.hacked = true
	mask_walk_finished.emit()

func finished_focus_change(focus: int) -> void:
	if focus == 1:
		EventBus.set_skip_button.emit(true)

func unlock_server(server_name: String) -> void:
	if server_name == "Server":
		return
	for i in range($ServerSprites.get_child_count()):
		var child = $ServerSprites.get_child(i)
		if child is Server and child.root_folder_name == server_name:
			child.hacked = false
			child.change_completed.connect(func unlock() -> void:
				if i != 0:
					$ServerSprites.get_child(i-1).visible = true
					$ServerSprites.get_child(i-1).pressable = true
				for child_child in child.get_children():
					if child_child is Server:
						child_child.visible = true
						child_child.pressable = true
				$ServerLine.compute_line()
				EventBus.play_monitor_sound.emit(server_unlock_sound, -32.5)
				child.change_completed.disconnect(child.change_completed.get_connections().back().callable)
			)
			EventBus.play_monitor_sound.emit(mask_server_start_hack_sound, -36)
