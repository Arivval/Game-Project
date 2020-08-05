extends Node2D


var play_asset_pack_manager
var pack_name

func _handle_download_success(success: bool, pack_state: PlayAssetPackState, \
	pack_location: PlayAssetPackLocation):
	  if success:
		  var asset_pack_path = pack_location.get_path() + "dlc.pck"
		  ProjectSettings.load_asset_pack(asset_pack_path)

func _ready():
	var asset_pack_request = play_asset_pack_manager.request_asset_pack(pack_name)
	asset_pack_request.connect("request_completed", self, "_handle_download_success")
