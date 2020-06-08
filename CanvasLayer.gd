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
signal restart_signal
signal back_signal
signal story_signal
signal endless_signal


func set_score(score):
	$score_label.text = str(score)
	$score_label_shadow.text = str(score)


func hide_start_screen():
	$title/title_text.hide()
	$title/title_text_shadow.hide()
	$start_button.hide()
	$story_mode_label.hide()
	$story_mode_selector.hide()
	$endless_mode_label.hide()
	$endless_mode_selector.hide()


func show_start_screen():
	$title/title_text.show()
	$title/title_text_shadow.show()
	$start_button.show()
	$story_mode_label.show()
	$story_mode_selector.show()
	$endless_mode_label.show()
	$endless_mode_selector.show()


func hide_in_game_screen():
	$score_label.hide()
	$score_label_shadow.hide()
	$tap_button.hide()


func show_in_game_screen():
	$score_label.show()
	$score_label_shadow.show()
	$tap_button.show()


func set_end_screen_score(score):
	var score_text = 'Score: ' + str(score)
	$end_game/end_game_text.text = score_text
	$end_game/end_game_text_shadow.text = score_text


func show_end_screen():
	$restart_button.show()
	$back_button.show()
	$restart_button2.show()
	$back_button2.show()
	$end_game/end_game_text.show()
	$end_game/end_game_text_shadow.show()


func hide_end_screen():
	$restart_button.hide()
	$back_button.hide()
	$restart_button2.hide()
	$back_button2.hide()
	$end_game/end_game_text.hide()
	$end_game/end_game_text_shadow.hide()


func _ready():
	pass


func _process(delta):
	pass


func _on_start_button_button_down():
	emit_signal('start_signal')


func _on_restart_button_pressed():
	emit_signal('restart_signal')


func _on_back_button_pressed():
	emit_signal('back_signal')


func _on_story_mode_selector_pressed():
	emit_signal('story_signal')


func _on_endless_mode_selector_pressed():
	emit_signal('endless_signal')
