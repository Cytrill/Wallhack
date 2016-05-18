extends Node2D

const GS_WAIT_FOR_PLAYERS = 0
const GS_RUNNING = 1
const GS_PAUSE = 2
const GS_GAME_OVER = 3
const GS_RESTART = 4

var game_state = 0
var prev_game_state = 0
var next_game_state = GS_WAIT_FOR_PLAYERS
var state_time_elapsed = 0
var time_elapsed = 0

var countdown_started = false
var timeout_time = 30 #In Seconds
var time_remaining = timeout_time

var viewport_width
var viewport_height
var pl_number = 0
var pl_player = preload("res://player.scn")
const colarray = [Color(1, 0, 0), Color(0, 1, 0), Color(0, 0, 1), Color(1, 1, 0), Color(0, 1, 1), Color(1, 0, 1),
	Color(0.5, 0, 0), Color(0, 0.5, 0), Color(0, 0, 0.5), Color(0.5, 0.5, 0), Color(0, 0.5, 0.5), Color(0.5, 0, 0.5),
	Color(1, 0.5, 0), Color(0, 1, 0.5), Color(1, 0, 0.5), Color(0.5, 1, 0), Color(0, 0.5, 1), Color(0.5, 0, 1)]

#var paused = true
#var pause_pressed = false


func _ready():
	# Initialization here
	set_fixed_process(true)
	
	viewport_width = get_viewport_rect().end.x
	viewport_height = get_viewport_rect().end.y
	
	"""for player in get_children():
		randomize()
		print(str(player.get_type()))
		if player.get_type() == "RigidBody2D":
			player.set_global_pos(Vector2(rand_range(20, viewport_width - 20), rand_range(20, viewport_height - 20)))
			player.set_rot(rand_range(-3.1415, 3.1415))
	get_tree().set_pause(true)"""


func _fixed_process(delta):
	#for trace in get_node("/root/World/TraceViewport").get_children():
	#	print(trace.get_name())
	#	print("  " + str(trace.get_global_pos().x) + " | " + str(trace.get_global_pos().y))
	
	#State Machine:
	prev_game_state = game_state
	game_state = next_game_state
	
	if (prev_game_state != game_state):
		state_time_elapsed = 0
	state_time_elapsed += delta
	
	if (game_state == GS_WAIT_FOR_PLAYERS):
		gs_waitforplayers(delta)
	elif (game_state == GS_RUNNING):
		gs_running(delta)
	elif (game_state == GS_GAME_OVER):
		gs_game_over(delta)
	elif (game_state == GS_PAUSE):
		gs_pause(delta)
	
	"""
	#get_node("Background").set_region_rect(get_viewport_rect())
	get_node("Background").set_texture(get_node("TraceViewport").get_render_target_texture())
	if Input.is_action_pressed("game_pause") && !pause_pressed:
		if paused:
			get_tree().set_pause(false)
			paused = false
		elif !paused:
			get_tree().set_pause(true)
			paused = true
	pause_pressed = Input.is_action_pressed("game_pause")"""


func get_game_state():
	return game_state


func gs_running(delta):
	if get_node("/root/World/Countdown").is_visible():
		get_node("/root/World/Countdown").hide()
	get_node("Background").set_region_rect(get_viewport_rect())
	get_node("Background").set_texture(get_node("TraceViewport").get_render_target_texture())


func gs_waitforplayers(delta):
	if (prev_game_state == GS_WAIT_FOR_PLAYERS):
		time_elapsed += delta
	next_game_state = GS_WAIT_FOR_PLAYERS
	
	#Reset countdown after two Players have joined the game:
	if (get_node("Players").get_child_count() >= 2):
		#Start countdown after two Players have joined the game:
		
		if (!countdown_started):
			time_elapsed = 0
			countdown_started = true
			time_remaining = timeout_time - time_elapsed
		else:
			time_remaining -= delta
	
	if (time_remaining <= 0):
		time_elapsed = 0 #Reset Timer
		next_game_state = GS_RUNNING
		get_node("Countdown").hide()
	elif (countdown_started):
		var m = floor(time_remaining / 60)
		var s = (int(floor(time_remaining)) % 60)
		get_node("Countdown").set_text(str(m) + ":" + str(s))
	
	for i in range(0,1024):
			if Input.is_joy_button_pressed(i, 0):
				if (!get_node("Players").has_node(cytrill.get_name(i))):
					print("Button has been presed!")
					
					print(cytrill.get_name(i) + " has joined the game!")
					var player = pl_player.instance()
					player.set_name(cytrill.get_name(i))
					player.set_global_pos(Vector2(rand_range(20, viewport_width - 20), rand_range(20, viewport_height - 20)))
					player.set_rot(rand_range(-3.1415, 3.1415))
					player.player_name = cytrill.get_name(i)
					player.player_color = Color(colarray[pl_number].r*255, colarray[pl_number].g*255, colarray[pl_number].b*255)
					player.joystick_number = i
					player.player_number = pl_number
					#last_team_assigend+=1
					#if (last_team_assigend > 3):
					#	last_team_assigend = 0
					#player.team = last_team_assigend
					get_node("Players").add_child(player)
					#player.init_player()
					cytrill.set_led(i, 0, colarray[pl_number].r*255, colarray[pl_number].g*255, colarray[pl_number].b*255, 1)
					cytrill.set_led(i, 1, 0, 0, 0, 0)
					pl_number += 1
