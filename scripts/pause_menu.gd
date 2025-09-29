class_name PauseMenu extends Control

var pause_open: bool = false

func show_pause_menu() -> void:
	if is_inside_tree():
		get_tree().paused = true
	visible = true
	$Layout.visible = true
	pause_open = true

func show_options_menu() -> void:
	visible = true
	$OptionsMenu.visible = true
	$Layout.visible = false

func back() -> void:
	if $OptionsMenu.visible:
		$OptionsMenu.visible = false
		if pause_open:
			$Layout.visible = true
	elif $Layout.visible:
		visible = false
		$Layout.visible = false
		pause_open = false
		if is_inside_tree():
			get_tree().paused = false

func _on_options_button_pressed() -> void:
	show_options_menu()

func _on_continue_button_pressed() -> void:
	back()

func _on_options_menu_back() -> void:
	back()
