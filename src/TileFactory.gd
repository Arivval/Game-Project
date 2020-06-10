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
	The procedural level generation is handled by a tiling approach
	When a new tile enters the screen, the next tile is selected randomly
	from tiles/ folder. 
"""


extends Node2D



var tile_names = ['double_diamond_l_1', 'double_diamond_l_2',
'double_diamond_l_3', 'double_diamond_l_4', 'double_diamond_r_1', 
'double_diamond_r_2', 'double_diamond_r_3', 'double_diamond_r_4',
'single_diamond_l_1', 'single_diamond_l_2', 'single_diamond_l_3',
'single_diamond_r_1', 'single_diamond_r_2', 'single_diamond_r_3',
'lambda_r_1', 'lambda_r_2', 'lambda_r_3',
'lambda_l_1', 'lambda_l_2', 'lambda_l_3',
'congested_1', 'congested_2']


var parent_node
var instantiated = false
var tile_height = -200


func _ready():
	parent_node = get_parent()


func _process(delta):
	pass


func randomly_load_next_tile():
	# create base tile and randomly select instantiate obstacles
	var next_tile_name = tile_names[randi()%len(tile_names)]
	next_tile_name = 'tiles/' + next_tile_name + '.tscn'
	var next_tile_base = load('tiles/TileFactory.tscn').instance()
	var next_tile_obstacle = load(next_tile_name).instance()

	# the position of the next tile needs to be above the current tile
	next_tile_base.add_child(next_tile_obstacle)
	
	var next_tile_height = next_tile_obstacle.get_node('height').position.y
	next_tile_base.tile_height = next_tile_height

	parent_node.add_child(next_tile_base)
	
	var buffer_zone_height = 0
	next_tile_base.position.y = (position.y + tile_height - 
		buffer_zone_height)
	parent_node.instantiated_obstacles.append(next_tile_base)


# whenever a tile enters the screen, we need to randomly select and append
# the next tile
func _on_EntryVisibilityNotifier2D_screen_entered():
	if !instantiated:
		randomly_load_next_tile()
		instantiated = true # this call should only be called once


# whnever a tile exits the screen, we need to queue_free it in order to save
# resources
func _on_ExitVisibilityNotifier2D_screen_exited():
	queue_free()
	parent_node.instantiated_obstacles.erase(self)

