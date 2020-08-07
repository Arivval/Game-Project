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
	Object used to render a list of PackDownloadDiv objects given an Array of packNames
"""

extends Node2D

const pack_download_div_scene = preload("res://pad_ui/pack_download_div.tscn")
const div_height = 90

var pack_names : Array
var pad_manager : PlayAssetPackManager

func init(_pack_names : Array, _pad_manager : PlayAssetPackManager):
	pack_names = _pack_names
	pad_manager = _pad_manager
	
	for i in range(pack_names.size()):
		var pack_download_div_instance = pack_download_div_scene.instance()
		pack_download_div_instance.position += Vector2(0, div_height*i)
		pack_download_div_instance.init(pack_names[i], pad_manager)
		add_child(pack_download_div_instance)
	

