class_name PauseMenu extends Control

var pause_open: bool = false

func _ready() -> void:
	EventBus.continue_to_back_to_title.connect(continue_to_back_to_title)

func show_pause_menu() -> void:
	if is_inside_tree():
		get_tree().paused = true
	visible = true
	$Layout.visible = true
	pause_open = true
	$Layout/ContinueButton.grab_focus()

func show_options_menu() -> void:
	visible = true
	$OptionsMenu.visible = true
	$Layout.visible = false
	$OptionsMenu/Layout/ScrollContainer/TableLayout/SensitivitySlider.grab_focus()

func back() -> void:
	if $OptionsMenu.visible:
		$OptionsMenu.visible = false
		if pause_open:
			$Layout.visible = true
			$Layout/OptionsButton.grab_focus()
		else:
			visible = false
			EventBus.back_from_options.emit()
	elif $Layout.visible:
		visible = false
		$Layout.visible = false
		pause_open = false
		EventBus.paused_change.emit(false)
		EventBus.back_from_options.emit()
		if is_inside_tree():
			get_tree().paused = false

func continue_to_back_to_title() -> void:
	$Layout/ContinueButton.text = tr("back_to_title_button")

func _on_options_button_pressed() -> void:
	show_options_menu()

func _on_continue_button_pressed() -> void:
	$Layout/ContinueButton.text = tr("continue_button")
	back()

func _on_restart_button_pressed() -> void:
	EventBus.restart_game.emit()

func _on_options_menu_back() -> void:
	back()
