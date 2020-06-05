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

func _ready():
	pass

func _process(delta):
	pass

func _on_Timer_timeout():
	score += 1
	$CanvasLayer.set_score(score)


