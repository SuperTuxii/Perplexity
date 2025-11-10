class_name TitleScreen extends Node3D

signal start_game
signal start_tutorial
signal show_options_menu

var move_tween: Tween

func _ready() -> void:
	randomize_movement()
	$Menu/VBoxContainer/StartButton.grab_focus()
	EventBus.back_from_options.connect(_on_back_from_options)

func randomize_movement() -> void:
	if move_tween:
		move_tween.kill()
	move_tween = create_tween()
	$Camera3D.rotation = Vector3()
	move_tween.tween_property($Camera3D, "rotation", Vector3(0, -TAU, 0), 90)
	move_tween.tween_callback(randomize_movement)

func _on_back_from_options() -> void:
	$Menu/VBoxContainer/OptionsButton.grab_focus()

func _on_visibility_changed() -> void:
	if !visible and move_tween:
		move_tween.kill()
	elif visible:
		randomize_movement()
	$Menu.visible = visible

func _on_start_button_pressed() -> void:
	start_game.emit()

func _on_tutorial_button_pressed() -> void:
	start_tutorial.emit()

func _on_options_button_pressed() -> void:
	show_options_menu.emit()
