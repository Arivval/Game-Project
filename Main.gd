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
	$Timer.start()
	$Player.start_game()

func end_game():
	$Timer.stop()

func _ready():
	pass

func _process(delta):
	pass

func _on_Timer_timeout():
	score += 1
	$CanvasLayer.set_score(score)


