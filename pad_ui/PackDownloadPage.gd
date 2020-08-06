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
const div_height = 90

var pack_names
var pad_manager

func init(_pack_names : Array, _pad_manager : PlayAssetPackManager):
	pack_names = _pack_names
	pad_manager = _pad_manager
	var div_count = 0
	for pack_name in pack_names:
		var pack_download_div_instance = pack_download_div_scene.instance()
		pack_download_div_instance.position += Vector2(0, div_height*div_count)
		# pack_download_div_instance.init(pack_name)
		pack_download_div_instance.pad_manager = get_node("/root/PlayAssetPackManager")
		pack_download_div_instance.init(pack_name, pad_manager)
		add_child(pack_download_div_instance)
		div_count += 1

