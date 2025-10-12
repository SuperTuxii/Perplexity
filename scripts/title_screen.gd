class_name TitleScreen extends Node3D

signal start_game
signal start_tutorial
signal show_options_menu


func _on_visibility_changed() -> void:
	$Menu.visible = visible

func _on_start_button_pressed() -> void:
	start_game.emit()

func _on_tutorial_button_pressed() -> void:
	start_tutorial.emit()

func _on_options_button_pressed() -> void:
	show_options_menu.emit()
