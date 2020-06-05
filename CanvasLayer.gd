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

extends CanvasLayer

signal start_signal


func set_score(score):
	$score_label.text = str(score)
	$score_label_shadow.text = str(score)

func hide_start_screen():
	$title/title_text.hide()
	$title/title_text_shadow.hide()
	$start_button.hide()

func show_start_screen():
	$title/title_text.show()
	$title/title_text_shadow.show()
	$start_button.show()

func hide_in_game_screen():
	$score_label.hide()
	$score_label_shadow.hide()

func show_in_game_screen():
	$score_label.show()
	$score_label_shadow.show()


func _ready():
	pass

func _process(delta):
	pass

func _on_start_button_button_down():
	emit_signal('start_signal')
