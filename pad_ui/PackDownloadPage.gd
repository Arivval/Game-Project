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
signal fetched_pack(pack_name)
signal removed_pack(pack_name)

extends Node2D

const pack_download_div_scene = preload("res://pad_ui/pack_download_div.tscn")
const div_height = 90

var pack_names : Array
var pad_manager : PlayAssetPackManager

# Functions used to route fetched/removed_pack signals emitted from each div
func _fetched_pack_signal_router(pack_name):
	emit_signal("fetched_pack", pack_name)

func _removed_pack_signal_router(pack_name):
	emit_signal("removed_pack", pack_name)

func init(_pack_names : Array, _pad_manager : PlayAssetPackManager):
	pack_names = _pack_names
	pad_manager = _pad_manager
	
	for i in range(pack_names.size()):
		var pack_download_div_instance = pack_download_div_scene.instance()
		pack_download_div_instance.position += Vector2(0, div_height*i)
		pack_download_div_instance.init(pack_names[i], pad_manager)
		pack_download_div_instance.connect("fetched_pack", self, "_fetched_pack_signal_router")
		pack_download_div_instance.connect("removed_pack", self, "_removed_pack_signal_router")
		add_child(pack_download_div_instance)
	

