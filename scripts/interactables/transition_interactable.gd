class_name TransitionInteractable
extends Interactable

@export var target_scene : String

@onready var _player_data : PlayerData = get_node("/root/PlayerData")

func _on_clicked():
	# get the player to walk towards this object (only along the x axis)
	var target = global_position
	target.y = _player_data.get_position().y
	_player_data.get_player().walk_to(target)

	var transition := Transitioner.new(true, target_scene)
	add_child(transition)