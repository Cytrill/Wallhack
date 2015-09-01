extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Initialization here
	var viewport_width = get_viewport_rect().end.x
	var viewport_height = get_viewport_rect().end.y
	
	#get_node("Background").get_texture().set_size_override(Vector2(viewport_width, viewport_height))
	#get_node("Background").set_z(-1)
	
	for player in get_children():
		randomize()
		print(str(player.get_type()))
		if player.get_type() == "RigidBody2D":
			player.set_global_pos(Vector2(rand_range(20, viewport_width - 20), rand_range(20, viewport_height - 20)))
			player.set_rot(rand_range(-3.1415, 3.1415))
	
	pass


