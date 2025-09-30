class_name ServerProtectGame extends Node2D

@onready
var firewall_control: Control = $Firewall

@export
var brick_scene: PackedScene = preload("res://scenes/monitor_scenes/firewall_brick_button.tscn")

var firewall_ports: int = 3

func _ready() -> void:
	create_firewall()

func create_firewall() -> void:
	for i in range(15):
		var brick: FirewallBrickButton = brick_scene.instantiate()
		firewall_control.add_child(brick)
		brick.position = Vector2(0, (52 * i) - 30)
		brick.disabled = true
	set_firewall_ports()

func set_firewall_ports() -> void:
	match firewall_ports:
		3:
			firewall_control.get_child(5).disabled = false
			firewall_control.get_child(5).port_number = 1
			firewall_control.get_child(7).disabled = false
			firewall_control.get_child(7).port_number = 2
			firewall_control.get_child(9).disabled = false
			firewall_control.get_child(9).port_number = 3
