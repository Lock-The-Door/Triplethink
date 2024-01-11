class_name Chocolate
extends Interactable

@onready var _player_data: PlayerData = get_node("/root/PlayerData")

func _on_clicked():
	print("Chocolate collected")
	_player_data.give_chocolate(1)
	queue_free()
