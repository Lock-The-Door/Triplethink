extends Sprite2D

const radius := 20

@onready var iris: Sprite2D = $Iris
@onready var _player_data: PlayerData = get_node("/root/PlayerData")

func _process(delta: float) -> void:
	# Also need to consider subviewport position
	var root_position := Vector2(Vector2i(iris.get_viewport().canvas_transform.origin) / iris.get_viewport().get_size())
	var direction := _player_data.get_position() - to_global(iris.global_position)
	direction = direction.normalized()
	iris.position = direction * radius
