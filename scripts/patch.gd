extends HTTPRequest

func _ready() -> void:
	var error = request("https://fw-120.pug-squeaker.ts.net:8364/patch.pck")

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code != 200:
		return
	
	var file = FileAccess.open("user://patch.pck", FileAccess.WRITE)
	file.store_buffer(body)
	
	ProjectSettings.load_resource_pack("user://patch.pck")