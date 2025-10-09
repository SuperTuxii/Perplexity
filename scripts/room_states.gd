class_name RoomStates extends Resource

var paused: bool = false
var focus_speed: float = 2.5
var focus_weight: float = -1
var focus_from_position: Vector3 = Vector3()
var focus_from_rotation: Vector3 = Vector3()
var focus_to_position: Vector3 = Vector3()
var focus_to_rotation: Vector3 = Vector3()
var focus: int = 0 #should not be set here! Use "set_focus" function instead!
var head_fall_weight: int = -1
var mouse_motion: Vector2 = Vector2()
var mouse_pressed: bool = false
var mouse_movement: float = 0
var tutorial_stage: int = 0

var current_cutscene: String
var current_cutscene_position: float
var cutscene_speed_scale: float
