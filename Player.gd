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
	"obstcales": 1,
	"walls": 2,	
}

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

# handle collision events with wall/obstacles
func _on_Player_area_entered(area):
	if area.collision_layer == CollisionLayer.walls:
		switch_direction()

