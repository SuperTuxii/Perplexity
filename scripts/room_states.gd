class_name RoomStates extends Resource

var paused: bool = false
var focus_tween: Tween
var focus_time: float = 0.4
var focussing: bool:
	get:
		return focus_tween and focus_tween.is_running()
var focus: int = 0 #should not be set here! Use "set_focus" function instead!
var head_fall_weight: int = -1
var mouse_motion: Vector2 = Vector2()
var mouse_pressed: bool = false
var mouse_movement: float = 0
var tutorial_stage: int = -1

var cutscene_playing: bool = true
var current_cutscene_position: float = 0

var door_open: bool = false
var monitor_look: bool = false
var drawer_positions: PackedFloat32Array = [0, 0, 0]
var musicbox_note_removed: bool = false
var musicbox_played: bool = false
var item: StringName = ""

var monitor_scene: MonitorScene
