extends Sprite2D

const radius := 20

@onready var iris: Sprite2D = $Iris
@onready var _player_data: PlayerData = get_node("/root/PlayerData")

func _process(_delta: float) -> void:
	var root_position: Vector2 = get_viewport().get_parent().get_parent().global_position + global_position
	var direction: Vector2 = _player_data.get_position() - root_position
	direction = direction.normalized()
	iris.position = direction * radius
