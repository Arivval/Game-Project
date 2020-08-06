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

const pack_download_div_scene = preload("res://pad_ui/pack_download_div.tscn")
const pack_download_page_scene = preload("res://pad_ui/pack_download_page.tscn")

var pack_download_page_instance
var available_packs = ["testpack"]
var downloaded_packs = {}

var score
var player_node
var canvas_node
var level_select_node = null
var camera_node
var player_init_position
var is_story_mode = true
var score_timer

var current_level = 'Level_1_1'
var current_level_instance

var instantiated_obstacles = []

var level_name_map = { 'Level_1_1': 'level 1-1', 'Level_1_2': 'level 1-2',}
var level_name_reverse_map = { 'level 1-1': 'Level_1_1', 
							'level 1-2': 'Level_1_2',}

func load_level(level_name):
	# we can't have duplicate or overlapping levels
	unload_current_level()
	var level_full_path = 'levels/' + level_name + '.tscn'
	var level_to_load = load(level_full_path).instance()
	current_level_instance = level_to_load
	add_child(level_to_load)


func unload_current_level():
	if current_level_instance != null:
		current_level_instance.queue_free()
		current_level_instance = null


# iterate throught all the instantiated obstacles during game play for
# endless mode, and free them
func unload_instantiated_obstacles():
	for obstacle in instantiated_obstacles:
		obstacle.queue_free()
	instantiated_obstacles = []
	
	
func start_game():
	hide_pad_ui()
	if is_story_mode:
		unload_instantiated_obstacles()
		load_level(current_level)
		canvas_node.hide_score_counter()
	else:
		unload_current_level()
		unload_instantiated_obstacles()
		var tile_factory = load('tiles/TileFactory.tscn').instance()
		add_child(tile_factory)
		canvas_node.show_score_counter()
	
	score = 0
	canvas_node.hide_start_screen()
	canvas_node.show_in_game_screen()
	canvas_node.set_score(score)
	randomize()
	score_timer.start()
	player_node.start_game()


func end_game():
	score_timer.stop()
	player_node.end_game()
	canvas_node.hide_in_game_screen()
	canvas_node.set_end_screen_score(score)
	canvas_node.show_end_screen()


func finished_level():
	camera_node.unlock_camera()
	canvas_node.show_level_complete_screen()


func proceed_to_next_level():
	camera_node.lock_camera()
	canvas_node.hide_level_complete_screen()
	player_node.end_game()
	canvas_node.hide_in_game_screen()
	to_main_screen()


func restart_game():
	player_node.reset_dot_position()
	canvas_node.hide_end_screen()
	start_game()


func to_main_screen():
	show_pad_ui()
	player_node.reset_dot_position()
	canvas_node.hide_end_screen()
	canvas_node.show_start_screen()


func load_level_select_screen():
	level_select_node = load('levels/LevelSelector.tscn').instance()
	level_select_node.init(downloaded_packs)
	add_child(level_select_node)
	unload_current_level()
	unload_instantiated_obstacles()
	canvas_node.hide_start_screen()
	# now move camera to the level select scene
	player_node.hide()
	player_node.position.y = 20


func set_level(level_name):
	current_level = level_name_reverse_map[level_name.to_lower()]
	level_select_node.queue_free()
	player_node.show()
	player_node.position.y = 892
	canvas_node.show_start_screen()
	enable_story_mode()
	

func enable_story_mode():
	is_story_mode = true
	$CanvasLayer/story_mode_label.bbcode_text = '[u]' + \
		level_name_map[current_level] + '[/u]'
	$CanvasLayer/endless_mode_label.bbcode_text = 'endless'


func enable_endless_mode():
	is_story_mode = false
	$CanvasLayer/story_mode_label.bbcode_text = level_name_map[current_level]
	$CanvasLayer/endless_mode_label.bbcode_text = '[u]endless[/u]'


# since our camera is locked on the player, we also need to move the
# background along with the player to make the map seem infinite
func sync_player_background_y():
	var y_delta = player_node.position.y - player_init_position.y

func show_pad_ui():
	pack_download_page_instance.show()

func hide_pad_ui():
	pack_download_page_instance.hide()

func instantiate_pad_ui():
	pack_download_page_instance = pack_download_page_scene.instance()
	var pad_manager = get_node("/root/PlayAssetPackManager")	
	pack_download_page_instance.init(available_packs, pad_manager)
	add_child(pack_download_page_instance)

func add_downloaded_pack(pack_name):
	downloaded_packs[pack_name] = true

func remove_downloaded_pack(pack_name):
	downloaded_packs.erase(pack_name)

func _ready():
	instantiate_pad_ui()
	# to save time, find node is only executed once
	player_node = $Player
	canvas_node = $CanvasLayer
	camera_node = player_node.find_node('Camera2D')
	
	score_timer = $Timer
	
	player_init_position = player_node.position
	
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

