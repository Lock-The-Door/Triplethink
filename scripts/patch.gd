extends Node

func _ready() -> void:
	_patch()
	
func _patch(patch_name = "patch.pck") -> void:
	var client := HTTPRequest.new()
	client.download_file = "data://patch/" + patch_name
	var request := client.request_raw("https://fw-120.pug-squeaker.ts.net/godot/triplethink/patch.pck")
	
	if request != OK:
		return
		
	ProjectSettings.load_resource_pack("data://patch/" + patch_name)
