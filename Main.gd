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

extends Node2D

var score
var player_node
var background_node
var player_init_position
var background_init_position


func start_game():
	score = 0
	$CanvasLayer.hide_start_screen()
	$CanvasLayer.show_in_game_screen()
	$CanvasLayer.set_score(score)
	$Timer.start()
	$Player.start_game()


func end_game():
	$Timer.stop()
	$Player.end_game()
	$CanvasLayer.hide_in_game_screen()
	$CanvasLayer.set_end_screen_score(score)
	$CanvasLayer.show_end_screen()


func restart_game():
	$Player.reset_dot_position()
	$CanvasLayer.hide_end_screen()
	start_game()


func to_main_screen():
	$Player.reset_dot_position()
	$CanvasLayer.hide_end_screen()
	$CanvasLayer.show_start_screen()


# since our camera is locked on the player, we also need to move the
# background along with the player to make the map seem infinite
func sync_player_background_y():
	var y_delta = player_node.position.y - player_init_position.y
	background_node.rect_position.y = background_init_position.y + y_delta


func _ready():
	# to save time, find node is only executed once
	player_node = $Player
	background_node = $ColorRect
	
	player_init_position = player_node.position
	background_init_position = background_node.rect_position


func _process(delta):
	sync_player_background_y()


func _on_Timer_timeout():
	score += 1
	$CanvasLayer.set_score(score)


