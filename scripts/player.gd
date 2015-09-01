
extends KinematicBody2D

export var color = Color(1, 0, 0)
export var player_number = 0
var rot_speed = 2
var move_speed = 50
var positions = []
var timer = 0

func _ready():
	# Initialization here
	get_node("Sprite").set_modulate(color)
	set_fixed_process(true)
	pass

func _fixed_process(delta):
	var trace_tex = preload("res://res/trace.png")
	timer += delta
	
	if timer > 0.03:
		var new_trace = Sprite.new()
		get_parent().add_child(new_trace)
		new_trace.set_global_pos(get_global_pos())
		new_trace.set_scale(Vector2(0.2, 0.2))
		new_trace.set_texture(trace_tex)
		new_trace.set_modulate(color)
		timer = 0
	
	var move1 = Vector2(move_speed*delta, move_speed*delta)
	var move2 = move1.rotated(get_rot())
	move(move2)
	
	#if (is_colliding()):
#		print("Collision!")
	
	if (Input.is_action_pressed("left_"+str(player_number))):
		set_rot(get_rot()+(rot_speed*delta))
	elif (Input.is_action_pressed("right_"+str(player_number))):
		set_rot(get_rot()-(rot_speed*delta))