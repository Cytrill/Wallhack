extends Node2D

var paused = true
var pause_pressed = false

func _ready():
	# Initialization here
	set_fixed_process(true)
	var viewport_width = get_viewport_rect().end.x
	var viewport_height = get_viewport_rect().end.y
	
	for player in get_children():
		randomize()
		print(str(player.get_type()))
		if player.get_type() == "RigidBody2D":
			player.set_global_pos(Vector2(rand_range(20, viewport_width - 20), rand_range(20, viewport_height - 20)))
			player.set_rot(rand_range(-3.1415, 3.1415))
	get_tree().set_pause(true)

func _fixed_process(delta):
	#get_node("Background").set_region_rect(get_viewport_rect())
	get_node("Background").set_texture(get_node("TraceViewport").get_render_target_texture())
	if Input.is_action_pressed("game_pause") && !pause_pressed:
		if paused:
			get_tree().set_pause(false)
			paused = false
		elif !paused:
			get_tree().set_pause(true)
			paused = true
	pause_pressed = Input.is_action_pressed("game_pause")