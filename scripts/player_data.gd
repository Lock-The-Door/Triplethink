extends Node

const CHARACTER_NAME = "6079 Winston Smith"

var _global_position := Vector2.ZERO
var _chocolate := 0
var _player: Player = null

func give_chocolate(count: int) -> void:
	_chocolate += count
	print("Player now has ", count, " chocolate")

func update_active_player(player: Player) -> void:
	_player = player

func update_position(position: Vector2) -> void:
	_global_position = position

func get_position() -> Vector2:
	return _global_position

func get_player() -> Player:
	return _player