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

extends Button


# this button can also be the DLC button, in which case we shoule not
# treat it as a level selector
var is_level_select_button = true

func _ready():
	if self.text == 'Get More Levels':
		is_level_select_button = false

func _on_Button_pressed():
	Input.vibrate_handheld(10)
	if is_level_select_button:
		var main_node = get_node('/root/Node2D')
		main_node.set_level(self.text)

