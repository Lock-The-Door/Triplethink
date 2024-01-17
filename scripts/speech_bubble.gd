class_name SpeechBubble
extends Control

const BUBBLE_PADDING = 10

@export var text: String = "Whoops! I don't know what to say!"
@export var width: int = 200
@export var characters_per_second: int = 20
@export var target: Node = null

@onready var bubble: NinePatchRect = $Bubble
@onready var arrow: TextureRect = $Bubble/Arrow
@onready var label: Label = $Bubble/Text

var time = 0.0

func _ready():
	var player_data: PlayerData = get_node("/root/PlayerData")
	label.text = player_data.substitute_text(text)
	size.x = width
	position.x -= size.x / 2

	if target == null:
		arrow.visible = false
	else:
		arrow.pivot_offset = Vector2(arrow.size.x / 2, 0)
	

func _process(delta):
	time += delta

	label.visible_characters = int(time * characters_per_second)

	if arrow.visible == false:
		return

	var direction = ((target.global_position) - (bubble.global_position + bubble.size/2)).normalized()
	var angle = atan2(direction.y, direction.x)
	# arrow at 0 is pointing down
	arrow.rotation_degrees = angle * 180 / PI - 90
