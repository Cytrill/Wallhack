
extends RigidBody2D

export var color = Color(1, 0, 0)
export var player_number = 0
var alive = true
var rot_speed = 2
var move_speed = 30
var old_position
var timer = 0
var totaltime = 0
var trace = preload("res://trace.scn")

func _ready():
	# Initialization here
	get_node("Sprite").set_modulate(color)
	old_position = get_global_pos()
	set_fixed_process(true)
	pass

func _fixed_process(delta):
	timer += delta
	totaltime += delta
	
	if alive:
		if timer > 0.05:
			var new_trace = trace.instance()
			get_parent().add_child(new_trace)
			new_trace.set_global_pos(old_position)
			new_trace.get_node("Sprite").set_modulate(color)
			timer = 0
			old_position = get_global_pos()
		
		var move1 = Vector2(move_speed*delta, move_speed*delta)
		var move2 = move1.rotated(get_rot())
		set_pos(get_pos()+move2)
		
		if (totaltime > 1):
			for body in get_colliding_bodies():
				alive = false
		
		if (Input.is_action_pressed("left_"+str(player_number))):
			set_rot(get_rot()+(rot_speed*delta))
		elif (Input.is_action_pressed("right_"+str(player_number))):
			set_rot(get_rot()-(rot_speed*delta))