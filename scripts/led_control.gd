extends Node

var udp_socket = PacketPeerUDP.new()
const LED_PORT = 9999
const LED_HOST = "127.0.0.1"

var leds_connected: bool:
	get:
		return udp_socket and udp_socket.is_socket_connected()

func _ready():
	udp_socket.connect_to_host(LED_HOST, LED_PORT)

func trigger_animation(animation_name: String, loop: bool = false, params: Dictionary = {}, speed: float = 1.0):
	if !leds_connected:
		push_warning("LEDs not connected!")
		return
	var command = {
		"animation": animation_name,
		"loop": loop,
		"speed": speed,
		"params": params
	}
	var json_string = JSON.stringify(command)
	udp_socket.put_packet(json_string.to_utf8_buffer())

func trigger_default() -> void:
	LEDControl.trigger_animation("pulse", true, {"color": [150, 50, 50]}, 0.5)
