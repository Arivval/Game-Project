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

var request_obj : PlayAssetPackFetchRequest
var pack_name
var pad_manager : PlayAssetPackManager

func init(_pack_name : String, _pad_manager : PlayAssetPackManager):
	pack_name = _pack_name
	pad_manager = _pad_manager
	$PackName.text = pack_name
	# get if it is installed or not
	var pack_installed = pad_manager.get_pack_location(pack_name) != null
	if pack_installed:
		_show_completed_ui()
	else:
		_show_init_ui()

func _convert_byte_to_stepified_megabytes(byte_value : int):
	return stepify(float(byte_value)/1000000, 0.01)

func _process(delta):
	if request_obj == null:
		return

	if request_obj != null and request_obj.get_state().get_status() != 0:
		var progress_percent = float(request_obj.get_state().get_bytes_downloaded())/float(request_obj.get_state().get_total_bytes_to_download())
		var downloaded_megabyte = str(_convert_byte_to_stepified_megabytes(request_obj.get_state().get_bytes_downloaded()))
		var totla_megabyte = str(_convert_byte_to_stepified_megabytes(request_obj.get_state().get_total_bytes_to_download()))
		if request_obj.get_state()._status != PlayAssetPackManager.AssetPackStatus.COMPLETED:
			$ProgressText.text = downloaded_megabyte + "MB/" + totla_megabyte + "MB"
			$Tween.interpolate_property($ProgressBar, "value", $ProgressBar.value, int(progress_percent*100), 0.4, Tween.TRANS_QUART, Tween.EASE_OUT)
			$Tween.start()

func _reset_download_ui():
	# $ProgressBar.value = 0
	$Tween.interpolate_property($ProgressBar, "value", $ProgressBar.value, 0, 0.01, Tween.TRANS_QUART, Tween.EASE_OUT)
	$Tween.start()
	$ProgressText.text = "-MB/-MB"
	
func _on_cancel_button_pressed():
	_hide_downloading_ui()
	_show_init_ui()
	pad_manager.cancel_asset_pack_request(pack_name)

func _on_retry_button_pressed():
	# clear previous download value
	request_obj = pad_manager.fetch_asset_pack(pack_name)
	request_obj.connect("request_completed", self, "handle_request_completed")
	_reset_download_ui()
	_hide_faileded_ui()
	call_deferred("_show_downloading_ui")

func _on_download_button_pressed():
	# clear previous download value
	request_obj = pad_manager.fetch_asset_pack(pack_name)
	request_obj.connect("request_completed", self, "handle_request_completed")
	_reset_download_ui()
	_hide_init_ui()
	call_deferred("_show_downloading_ui")

func _on_delete_button_pressed():
	_hide_completed_ui()
	_show_init_ui()
	pad_manager.remove_pack(pack_name)
	self.get_parent().get_parent().remove_downloaded_pack(pack_name)

func _show_init_ui():
	$TerminalStateText.text = "Not Installed"
	$TerminalStateText.show()
	$DownloadButton.show()

func _hide_init_ui():
	$TerminalStateText.hide()
	$DownloadButton.hide()

func _show_downloading_ui():
	$ProgressBar.show()
	$ProgressText.show()
	$CancelButton.show()

func _hide_downloading_ui():
	$ProgressBar.hide()
	$ProgressText.hide()
	$CancelButton.hide()

func _show_completed_ui():
	$TerminalStateText.text = "    Download Completed"
	$TerminalStateText.show()
	$CompletedIcon.show()
	$DeleteButton.show()

func _hide_completed_ui():
	$CompletedIcon.hide()
	$TerminalStateText.hide()
	$DeleteButton.hide()

func _show_failed_ui():
	$TerminalStateText.text = "    Failed"
	$TerminalStateText.show()
	$ErrorIcon.show()
	$RetryButton.show()

func _hide_faileded_ui():
	$TerminalStateText.hide()
	$ErrorIcon.hide()
	$RetryButton.hide()

func handle_request_completed(pack_name, result : PlayAssetPackState, exception):
	_hide_downloading_ui()
	if result.get_status() == PlayAssetPackManager.AssetPackStatus.COMPLETED:
		var pack_location : PlayAssetPackLocation = pad_manager.get_pack_location(pack_name)
		var dlc_folder = pack_location.get_assets_path()
		ProjectSettings.load_resource_pack(dlc_folder + '/dlc.pck')
		_show_completed_ui()
		self.get_parent().get_parent().add_downloaded_pack(pack_name)
	else:
		_show_failed_ui()


func load_fake_asset_pack():
	var pack_size = 42000000
	var state_dict = {
		PlayAssetPackState._NAME_KEY: "packName",
		PlayAssetPackState._STATUS_KEY: PlayAssetPackManager.AssetPackStatus.DOWNLOADING,
		PlayAssetPackState._ERROR_CODE_KEY: PlayAssetPackManager.AssetPackErrorCode.NO_ERROR,
		PlayAssetPackState._BYTES_DOWNLOADED_KEY: 0,
		PlayAssetPackState._TOTAL_BYTES_TO_DOWNLOAD_KEY: pack_size,
		PlayAssetPackState._TRANSFER_PROGRESS_PERCENTAGE_KEY: 0
	}
	request_obj._state = PlayAssetPackState.new(state_dict)
	var timer = Timer.new()
	timer.set_wait_time(0.8)
	timer.one_shot = false
	self.add_child(timer)
	timer.start()
	for i in range(10):
		print("here!!!")
		request_obj._state._bytes_downloaded = pack_size*(i+1)/10
		yield(timer, "timeout")
	timer.queue_free()
	var completed_state_dict = {
		PlayAssetPackState._NAME_KEY: "packName",
		PlayAssetPackState._STATUS_KEY: PlayAssetPackManager.AssetPackStatus.COMPLETED,
		PlayAssetPackState._ERROR_CODE_KEY: PlayAssetPackManager.AssetPackErrorCode.NO_ERROR,
		PlayAssetPackState._BYTES_DOWNLOADED_KEY: 0,
		PlayAssetPackState._TOTAL_BYTES_TO_DOWNLOAD_KEY: pack_size,
		PlayAssetPackState._TRANSFER_PROGRESS_PERCENTAGE_KEY: 0
	}
	request_obj._on_state_updated(completed_state_dict)
