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

const CollisionLayer = {
	"obstacles": 1,
	"walls": 2,	
}

var trailing_tail
var previous_position
var x_speed = 400
var y_speed = -400
var velocity_vector = Vector2(x_speed, y_speed)
var moving_right = true

func switch_direction():
	moving_right = !moving_right
	velocity_vector.x *= -1
	# since player_dot is acutally a half circle, we need to flip its rotation
	$player_dot.rotation_degrees *= -1

# append new position into the Line2D of the trailing tail
# while removing old point
func update_tail(position_delta):
	var new_point = position_delta + trailing_tail.points[0]
	trailing_tail.add_point(new_point, 0)
	if len(trailing_tail.points) > 15:
		trailing_tail.remove_point(15)

# callback to react to player inputs 
func _input(event):
	if Input.is_action_just_pressed("switch_direction"):
		switch_direction()

func _ready():
	trailing_tail = get_owner().get_node("trailing_tail")

func _process(delta):
	var position_delta = velocity_vector * delta
	position += position_delta
	update_tail(position_delta)

# handle collision events with wall/obstacles
func _on_Player_area_entered(area):
	if area.collision_layer == CollisionLayer.walls:
		switch_direction()
	if area.collision_layer == CollisionLayer.obstacles:
		print('hit wall')

