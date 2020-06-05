"""
	Copyright 2020 Google LLC
	
	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at
	
		https://www.apache.org/licenses/LICENSE-2.0
	
	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
"""
"""
	Player.gd handles all the player sprite related logic
"""
extends Area2D

signal end_signal

const CollisionLayer = {
	"obstacles": 1,
	"left_wall": 2,
	"right_wall": 4,	
}

var trailing_tail
var previous_position
var x_speed = 0
var y_speed = 0
var velocity_vector = Vector2(x_speed, y_speed)
var moving_right = true
var started = false
var initial_position
var initial_tail_points
var screen_width
var player_radius

func start_game():
	velocity_vector = Vector2(400, -400)
	started = true


func end_game():
	velocity_vector = Vector2(0, 0)
	started = false


func switch_direction():
	moving_right = !moving_right
	velocity_vector.x *= -1
	# since player_dot is acutally a half circle, we need to flip its rotation
	$player_dot.rotation_degrees *= -1


func set_moving_right(condition):
	if !moving_right == condition:
		switch_direction()


# append new position into the Line2D of the trailing tail
# while removing old point
func update_tail(position_delta):
	var new_point = position_delta + trailing_tail.points[0]
	trailing_tail.add_point(new_point, 0)
	if len(trailing_tail.points) > 15:
		trailing_tail.remove_point(15)


# recover the position for dot and tail saved in initial_position
# and initial_tail_points
func reset_dot_position():
	position = initial_position
	trailing_tail.points = initial_tail_points
	moving_right = true
	$player_dot.rotation_degrees = 45.0


func is_player_out_of_bound():
	if position.x <= player_radius:
		set_moving_right(true)
	elif	 position.x >= screen_width - player_radius:
		set_moving_right(false)


# callback to react to player inputs 
func _input(event):
	if Input.is_action_just_pressed("switch_direction") and started:
		switch_direction()


func _ready():
	trailing_tail = get_owner().get_node("trailing_tail")
	initial_position = position
	initial_tail_points = trailing_tail.points
	screen_width = get_viewport_rect().size.x
	player_radius = $CollisionShape2D.shape.radius


func _process(delta):
	if started:
		var position_delta = velocity_vector * delta
		position += position_delta
		update_tail(position_delta)
		is_player_out_of_bound()


# handle collision events with wall/obstacles
func _on_Player_area_entered(area):
	if area.collision_layer == CollisionLayer.obstacles:
		emit_signal('end_signal')


