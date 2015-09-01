extends Node2D

var paused = true

func _ready():
	# Initialization here
	set_fixed_process(true)
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
	get_tree().set_pause(true)
	pass

func _fixed_process(delta):
	if Input.is_action_pressed("game_pause") && paused:
		get_tree().set_pause(false)
		paused = false
	elif Input.is_action_pressed("game_pause") && !paused:
		get_tree().set_pause(true)
		paused = true