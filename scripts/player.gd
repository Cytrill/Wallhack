extends Node2D

export var player_color = Color(1, 0, 0)
export var player_number = 0
export var joystick_number = -1
export var player_name = ""
var old_pos

# State
var alive = true
var painting = true
var label_hidden = false

# Timers
var totaltime = 0
var trace_timer = 0
var gap_timer = 0
var next_gap = 0
var gap_size = 0
var deathtimer = 0

# Config
var rot_speed = 2
var move_speed = 60
var viewport_boundary_offset = 4
var joy_tresh = 0.5

# Preloads
var trace = preload("res://trace.scn")
var label = preload("res://label.scn")
var trace_viewport = null
var player_trace = null

func _ready():
	# Initialization here
	get_node("Sprite").set_modulate(player_color)
	var cr = get_node("Particles").get_color_ramp().duplicate()
	var crc = cr.get_colors()
	crc.set(0, player_color)
	cr.set_colors(crc)
	get_node("Particles").set_color_ramp(cr)
	
	old_pos = Vector2(round(get_global_pos().x), round(get_global_pos().y))
	
	trace_viewport = get_node("/root/World/TraceViewport")
	player_trace = trace.instance()
	player_trace.set_name("trace_" + str(player_number))
	trace_viewport.add_child(player_trace)
	player_trace.set_global_pos(get_global_pos())
	player_trace.get_node("Sprite").set_modulate(player_color)
	
	set_fixed_process(true)
	next_gap = rand_range(1, 3)
	gap_size = rand_range(0.2, 0.8)

func _fixed_process(delta):
	if get_node("/root/World/").get_game_state() != 1:
		return
	if !alive && !label_hidden:
		deathtimer += delta
		if deathtimer > 5:
			label_hidden = true
			#var label_node = get_node("../death_label_"+str(player_number))
			#get_parent().remove_child(label_node)
			#label_node.queue_free()
	elif alive:
		# Update position?
		var new_pos = Vector2(round(get_global_pos().x), round(get_global_pos().y))
		if painting && new_pos != old_pos:
			get_node("/root/World").collision[old_pos] = 1
			old_pos = new_pos
		
		trace_timer += delta
		gap_timer += delta
		totaltime += delta
		randomize()
		
		if (trace_timer > 0.05):
			if painting:
				player_trace.set_global_pos(get_global_pos())
		
		if (gap_timer > next_gap) && painting:
			next_gap = rand_range(1, 3)
			gap_timer = 0
			painting = false
			
		if (gap_timer > gap_size) && !painting:
			gap_timer = 0
			gap_size = rand_range(0.2, 0.8)
			painting = true

		var move1 = Vector2(move_speed*delta, move_speed*delta)
		var move2 = move1.rotated(get_rot())
		set_pos(get_pos()+move2)
	
		if get_pos().x > get_viewport_rect().end.x-viewport_boundary_offset || get_pos().x < viewport_boundary_offset || get_pos().y > get_viewport_rect().end.y-viewport_boundary_offset || get_pos().y < viewport_boundary_offset:
			die()
			
		if Input.get_joy_axis(joystick_number, 0) > joy_tresh:
			set_rot(get_rot()-(rot_speed*delta))
		elif Input.get_joy_axis(joystick_number, 0) < -joy_tresh:
			set_rot(get_rot()+(rot_speed*delta))

func die():
	alive = false
	get_node("Particles").set_emitting(false)
	get_node("ParticlesDying").set_emitting(true)
	"""var new_label = label.instance()
	new_label.set_name("death_label_"+str(player_number))
	new_label.set_text("I survived for %.1f seconds!" % totaltime)
	get_parent().add_child(new_label)
	var label_pos = get_global_pos()
	if (label_pos.x > (get_viewport_rect().end.x - 100)):
		label_pos.x = label_pos.x - new_label.get_size().x
	if (label_pos.y > (get_viewport_rect().end.y - 20)):
		label_pos.y = label_pos.y - new_label.get_size().y
	new_label.set_pos(label_pos)"""
