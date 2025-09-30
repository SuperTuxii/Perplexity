class_name ServerProtectGame extends Node2D

@onready
var firewall_control: Control = $Firewall

@export
var brick_scene: PackedScene = preload("res://scenes/monitor_scenes/firewall_brick_button.tscn")

var firewall_ports: int = 3
var firewall_port_buttons: Array[FirewallBrickButton] = []

func _ready() -> void:
	create_firewall()

func create_firewall() -> void:
	for i in range(9):
		var brick: FirewallBrickButton = brick_scene.instantiate()
		firewall_control.add_child(brick)
		brick.position = Vector2(0, 83 * i - 12)
		brick.disabled = true
	set_firewall_ports()

func set_firewall_ports() -> void:
	match firewall_ports:
		3:
			firewall_port_buttons.append(firewall_control.get_child(2))
			firewall_port_buttons.append(firewall_control.get_child(4))
			firewall_port_buttons.append(firewall_control.get_child(6))
	for i in range(firewall_port_buttons.size()):
		firewall_port_buttons[i].disabled = false
		firewall_port_buttons[i].port_number = i + 1
