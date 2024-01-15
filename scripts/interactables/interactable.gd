class_name Interactable
extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var area: Area2D = get_node_or_null("Area2D")
@onready var tooltip: Label = get_node_or_null("Tooltip")
@onready var highlight_material: Material = material
var hovering = false

func _ready() -> void:
	material = null
	if tooltip != null:
		tooltip.hide()
		tooltip.z_index = 5

	if area == null:
		area = Area2D.new()
		var collider = CollisionShape2D.new()
		var shape = RectangleShape2D.new()
		shape.size = sprite.texture.get_size()
		collider.shape = shape
		area.add_child(collider)
		add_child(area)

	area.connect("mouse_entered", _on_mouse_entered)
	area.connect("mouse_exited", _on_mouse_exited)

func _process(_delta: float) -> void:
	if tooltip != null:
		tooltip.set_global_position(get_global_mouse_position() + Vector2(10, 10))

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if hovering:
				_on_clicked()

func _on_clicked():
	pass

func _on_mouse_entered():
	material = highlight_material
	if tooltip != null:
		tooltip.show()
	hovering = true
func _on_mouse_exited():
	material = null
	if tooltip != null:
		tooltip.hide()
	hovering = false
