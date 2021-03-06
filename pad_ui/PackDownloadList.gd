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
	Object used to render a list of PackDownloadListItem objects given an Array of packNames
"""
signal fetched_pack(pack_name)
signal removed_pack(pack_name)

extends Node2D

const PackDownloadListItemScene = preload("res://pad_ui/pack_download_list_item.tscn")
const LIST_ITEM_HEIGHT = 90

var pack_names : Array
var pad_manager : PlayAssetPackManager

# Functions used to route fetched/removed_pack signals emitted from each list item
func _fetched_pack_signal_router(pack_name):
	emit_signal("fetched_pack", pack_name)

func _removed_pack_signal_router(pack_name):
	emit_signal("removed_pack", pack_name)

func init(_pack_names : Array, _pad_manager : PlayAssetPackManager):
	pack_names = _pack_names
	pad_manager = _pad_manager
	
	for i in range(pack_names.size()):
		var pack_download_list_item_instance = PackDownloadListItemScene.instance()
		pack_download_list_item_instance.position += Vector2(0, LIST_ITEM_HEIGHT*i)
		pack_download_list_item_instance.init(pack_names[i], pad_manager)
		pack_download_list_item_instance.connect("fetched_pack", self, "_fetched_pack_signal_router")
		pack_download_list_item_instance.connect("removed_pack", self, "_removed_pack_signal_router")
		add_child(pack_download_list_item_instance)
	

