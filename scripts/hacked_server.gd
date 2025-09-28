class_name HackedServer extends AnimatedSprite2D

func _ready() -> void:
	play()

func _on_frame_changed() -> void:
	frame = randi_range(0, sprite_frames.get_frame_count(animation) - 1)
	speed_scale = randf_range(1, 1.5)
