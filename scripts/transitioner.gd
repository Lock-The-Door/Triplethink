class_name Transitioner
extends Control

@export var transition_time := 1
@export var transition_color := Color(0, 0, 0)
# @export var player_target := Vector2(0, 0)

var color_rect := ColorRect.new()
var transition_in := true
var target_scene: String = ""

func _init(transition_out := false, scene: String = "") -> void:
	transition_in = not transition_out
	target_scene = scene

func _ready() -> void:
	z_index = 1000
	add_child(color_rect)
	color_rect.size = get_viewport_rect().size
	color_rect.global_position = Vector2(-color_rect.size.x / 2, -color_rect.size.y / 2)

	if not transition_in:
		transition_color.a = 0
	# else:
	# 	var player_data: PlayerData = get_node("/root/PlayerData")
	# 	var player := player_data.get_player()
	# 	if player != null:
	# 		player.walk_to(player_target)

func _process(delta: float) -> void:
	if transition_in:
		transition_color.a = max(transition_color.a - delta / transition_time, 0)
	else:
		transition_color.a = min(transition_color.a + delta / transition_time, 1)

	color_rect.color = transition_color

	if transition_color.a == 0 and transition_in:
		queue_free()
	elif transition_color.a == 1 and not transition_in:
		get_tree().change_scene_to_file("res://scenes/" + target_scene + ".tscn")
