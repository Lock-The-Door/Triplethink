class_name Interactable
extends Node2D

@onready var sprite: Sprite2D = $Sprite2D

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if sprite.get_rect().has_point(to_local(event.position)):
				_on_clicked()

func _on_clicked():
	pass
