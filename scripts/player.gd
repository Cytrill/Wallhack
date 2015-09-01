extends RigidBody2D

export var color = Color(1, 0, 0)
export var player_number = 0
var alive = true
var rot_speed = 2
var move_speed = 30
var old_position
var trace_timer = 0
var painting = true
var gap_timer = 0
var next_gap = 0
var gap_size = 0
var totaltime = 0
var viewport_boundary_offset = 8
var trace = preload("res://trace.scn")
var label = preload("res://label.scn")

func _ready():
	# Initialization here
	get_node("Sprite").set_modulate(color)
	
	var cr = get_node("Particles").get_color_ramp()
	var crc = cr.get_colors()
	crc.set(0, color)
	cr.set_colors(crc)
	get_node("Particles").set_color_ramp(cr)
	
	old_position = get_global_pos()
	set_fixed_process(true)
	next_gap = rand_range(3, 6)
	gap_size = rand_range(0.2, 0.8)
	pass

func _fixed_process(delta):	
	if alive:
		trace_timer += delta
		gap_timer += delta
		totaltime += delta
		randomize()
		
		if (trace_timer > 0.05):
			old_position = get_global_pos()
			if painting:
				var new_trace = trace.instance()
				get_parent().add_child(new_trace)
				new_trace.set_global_pos(old_position)
				new_trace.get_node("Sprite").set_modulate(color)
				trace_timer = 0
		
		if (gap_timer > next_gap) && painting:
			next_gap = rand_range(3, 6)
			gap_timer = 0
			painting = false
			
		if (gap_timer > gap_size) && !painting:
			gap_timer = 0
			gap_size = rand_range(0.2, 0.8)
			painting = true
		
		var move1 = Vector2(move_speed*delta, move_speed*delta)
		var move2 = move1.rotated(get_rot())
		set_pos(get_pos()+move2)
		
		if (totaltime > 1):
			for body in get_colliding_bodies():
				die()
				
		if get_pos().x > get_viewport_rect().end.x-viewport_boundary_offset || get_pos().x < viewport_boundary_offset || get_pos().y > get_viewport_rect().end.y-viewport_boundary_offset || get_pos().y < viewport_boundary_offset:
			die()
		
		if (Input.is_action_pressed("left_"+str(player_number))):
			set_rot(get_rot()+(rot_speed*delta))
		elif (Input.is_action_pressed("right_"+str(player_number))):
			set_rot(get_rot()-(rot_speed*delta))

func die():
	alive = false
	get_node("Particles").set_emitting(false)
	var new_label = label.instance()
	new_label.set_text("I survived for %.1f seconds!" % totaltime)
	get_parent().add_child(new_label)
	var label_pos = get_global_pos()
	if (label_pos.x > (get_viewport_rect().end.x - 100)):
		label_pos.x = label_pos.x - new_label.get_size().x
	if (label_pos.y > (get_viewport_rect().end.y - 20)):
		label_pos.y = label_pos.y - new_label.get_size().y
	new_label.set_pos(label_pos)