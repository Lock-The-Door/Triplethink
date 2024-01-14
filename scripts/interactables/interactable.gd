class_name Interactable
extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var area: Area2D = $Area2D
@onready var highlight_material: Material = material

var hovering = false

func _ready() -> void:
	material = null

	area.connect("mouse_entered", _on_mouse_entered)
	area.connect("mouse_exited", _on_mouse_exited)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if hovering:
				_on_clicked()

func _on_clicked():
	pass

func _on_mouse_entered():
	material = highlight_material
	hovering = true
func _on_mouse_exited():
	material = null
	hovering = false