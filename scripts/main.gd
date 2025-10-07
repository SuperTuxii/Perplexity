class_name Main extends Node3D

@onready
var room: Room = $RoomHighQuality
@onready
var options: OptionsMenu = $PauseMenu/OptionsMenu
@onready
var screen_overlays: ScreenOverlays = $ScreenOverlays

var paused: bool:
	get:
		return $PauseMenu.pause_open
	set(value):
		if value:
			$PauseMenu.show_pause_menu()
		else:
			$PauseMenu.back()
var focus: int = 0:
	set(value):
		room.focus = value
	get:
		return room.focus
var tutorial_stage: int = 0

func _ready() -> void:
	room.main = self
	EventBus.focus_changed.connect(on_focus_changed)
	EventBus.finished_focus_change.connect(finished_focus)
	screen_overlays.show_drag_tutorial()
	screen_overlays.set_skip_button(true)
	screen_overlays.skipped.connect(skip_tutorial)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"): # Pause menu and exiting focus
		if focus <= 0:
			if tutorial_stage == 4:
				screen_overlays.hide_pause_tutorial()
				tutorial_stage = -1
				focus = -1
				screen_overlays.skipped.disconnect(skip_tutorial)
				room.start_cutscene.call_deferred() # Called deffered otherwise instantly skipped
				$PauseMenu.continue_to_start_game()
			paused = !paused
		else:
			focus = 0

func on_focus_changed(index: int) -> void:
	if index != -1 and tutorial_stage == -1:
		screen_overlays.set_skip_button(false)
	if index == 1 and tutorial_stage == 1:
		screen_overlays.hide_focus_tutorial()
		screen_overlays.show_unfocus_tutorial()
		tutorial_stage = 3

func finished_focus(index: int) -> void:
	# Actions when focus animation finishes
	match index:
		0:
			if tutorial_stage == 3:
				screen_overlays.hide_unfocus_tutorial()
				screen_overlays.show_pause_tutorial()
				tutorial_stage = 4
		1:
			if room.monitor_viewport.get_node("MonitorScene").security_breached_visible and tutorial_stage == -1:
				EventBus.set_security_breached.emit(false)
				room.alarm_ease_out()

func skip_tutorial() -> void:
	screen_overlays.hide_drag_tutorial()
	screen_overlays.hide_focus_tutorial()
	screen_overlays.hide_unfocus_tutorial()
	screen_overlays.hide_pause_tutorial()
	screen_overlays.skipped.disconnect(skip_tutorial)
	tutorial_stage = -1
	room.start_cutscene.call_deferred()
	$PauseMenu.continue_to_start_game()
	paused = true
