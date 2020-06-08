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
var canvas_node
var player_init_position
var background_init_position
var is_story_mode = true
var score_timer
var obstacle_spawn_timer

var current_level = 'Level_1_1'
var current_level_instance

func load_level(level_name):
	unload_current_level()
	var level_full_path = level_name + '.tscn'
	var level_to_load = load(level_full_path).instance()
	current_level_instance = level_to_load
	add_child(level_to_load)


func unload_current_level():
	if current_level_instance != null:
		current_level_instance.queue_free()
		current_level_instance = null

func start_game():
	load_level(current_level)
	score = 0
	canvas_node.hide_start_screen()
	canvas_node.show_in_game_screen()
	canvas_node.set_score(score)
	randomize()
	score_timer.start()
	player_node.start_game()
	
	obstacle_spawn_timer.start()


func end_game():
	score_timer.stop()
	player_node.end_game()
	canvas_node.hide_in_game_screen()
	canvas_node.set_end_screen_score(score)
	canvas_node.show_end_screen()


func restart_game():
	player_node.reset_dot_position()
	canvas_node.hide_end_screen()
	start_game()


func to_main_screen():
	player_node.reset_dot_position()
	canvas_node.hide_end_screen()
	canvas_node.show_start_screen()


func enable_story_mode():
	is_story_mode = true
	$CanvasLayer/story_mode_label.bbcode_text = '[u]story[/u]'
	$CanvasLayer/endless_mode_label.bbcode_text = 'endless'


func enable_endless_mode():
	is_story_mode = false
	$CanvasLayer/story_mode_label.bbcode_text = 'story'
	$CanvasLayer/endless_mode_label.bbcode_text = '[u]endless[/u]'


# since our camera is locked on the player, we also need to move the
# background along with the player to make the map seem infinite
func sync_player_background_y():
	var y_delta = player_node.position.y - player_init_position.y
	background_node.rect_position.y = background_init_position.y + y_delta


func _ready():
	# to save time, find node is only executed once
	player_node = $Player
	background_node = $ColorRect
	canvas_node = $CanvasLayer
	
	score_timer = $Timer
	obstacle_spawn_timer = $ObstacleSpawnTimer
	
	player_init_position = player_node.position
	background_init_position = background_node.rect_position
	
	# we need to initialize the UI elements to reflect the current mode
	if is_story_mode: 
		enable_story_mode() 
	else: 
		enable_endless_mode()


func _process(delta):
	sync_player_background_y()


func _on_Timer_timeout():
	score += 1
	canvas_node.set_score(score)


func _on_ObstacleSpawnTimer_timeout():
	pass
