extends Node2D

const pack_download_div_scene = preload("res://pad_ui/pack_download_div.tscn")
var pack_names
var pad_manager

func init(_pack_names : Array, _pad_manager : PlayAssetPackManager):
	pack_names = _pack_names
	var div_height = 90
	var div_count = 0
	pad_manager = _pad_manager
	for pack_name in pack_names:
		var pack_download_div_instance = pack_download_div_scene.instance()
		pack_download_div_instance.position += Vector2(0, div_height*div_count)
		# pack_download_div_instance.init(pack_name)
		pack_download_div_instance.pad_manager = get_node("/root/PlayAssetPackManager")
		pack_download_div_instance.init(pack_name, pad_manager)
		add_child(pack_download_div_instance)
		div_count += 1

func _on_ExitButton_pressed():
	pass # Replace with function body.
