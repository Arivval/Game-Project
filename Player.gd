"""
	Player.gd handles all the player sprite related logic
"""

extends Area2D

var x_speed = 300
var y_speed = -300
var velocity_vector = Vector2(x_speed, y_speed)
var moving_right = true

func switch_direction():
	moving_right = !moving_right
	velocity_vector.x *= -1

# callback to react to player inputs 
func _input(event):
	if Input.is_action_just_pressed("switch_direction"):
		switch_direction()

func _ready():
	pass

func _process(delta):
	position += velocity_vector * delta
	
