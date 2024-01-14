extends Node

var _global_position := Vector2.ZERO
var _chocolate := 0

func give_chocolate(count: int) -> void:
	_chocolate += count
	print("Player now has ", count, " chocolate")

func update_position(position: Vector2) -> void:
	_global_position = position

func get_position() -> Vector2:
	return _global_position
