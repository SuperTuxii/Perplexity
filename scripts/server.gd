class_name Server extends Area2D

@onready
var sprite: AnimatedSprite2D = $ServerSprite

@export
var hacked: bool = false:
	set(value):
		if hacked != value:
			hacked = value
			switch_type()

func _ready() -> void:
	sprite.play()
	sprite.animation = "hacked_server" if hacked else "normal_server"

func switch_type() -> void:
	sprite.animation = "changing_server"
	sprite.frame = 0 if hacked else sprite.sprite_frames.get_frame_count(sprite.animation)
	sprite.speed_scale = 1 if hacked else -1

func _on_server_sprite_animation_looped() -> void:
	if sprite.animation == "changing_server":
		sprite.animation = "hacked_server" if hacked else "normal_server"
		sprite.frame = randi_range(0, sprite.sprite_frames.get_frame_count(sprite.animation) - 1)
		sprite.speed_scale = randf_range(0.5, 1.5)

func _on_server_sprite_frame_changed() -> void:
	if sprite.animation != "changing_server":
		sprite.frame = randi_range(0, sprite.sprite_frames.get_frame_count(sprite.animation) - 1)
		sprite.speed_scale = randf_range(0.5, 1.5)


func _on_mouse_entered() -> void:
	$Panel.visible = hacked

func _on_mouse_exited() -> void:
	$Panel.visible = false
