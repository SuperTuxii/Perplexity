class_name ServerLines extends Line2D

@export
var server_sprites_collection: Node2D

func _ready() -> void:
	compute_line()
	

func compute_line() -> void:
	if server_sprites_collection != null:
		clear_points()
		for child in server_sprites_collection.get_children():
			if child is Server and child.visible:
				add_point(child.global_position)
				create_line_recursive(child)
	else:
		push_warning("Server Sprites Collection for ServerLines is not set!")

func create_line_recursive(object: Node2D) -> void:
	for child in object.get_children():
		if child is Server and child.visible:
			add_point(child.global_position)
			create_line_recursive(child)
			add_point(object.global_position)
