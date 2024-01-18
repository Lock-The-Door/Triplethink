extends HTTPRequest

func _ready() -> void:
	connect("request_completed", _on_request_completed)
	var error = request("https://pc-08.pug-squeaker.ts.net/godot/triplethink/patch.pck")

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code != 200:
		return
	
	var file = FileAccess.open("user://patch.pck", FileAccess.WRITE)
	file.store_buffer(body)
	
	ProjectSettings.load_resource_pack("user://patch.pck")
