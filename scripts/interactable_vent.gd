extends Interactable

@onready var _cover: RigidBody2D = get_node("Cover")
@onready var _tooltip: Label = get_node("Tooltip")
@onready var _player_data: PlayerData = get_node("/root/PlayerData")

func _on_clicked() -> void:
	# Move player
	_player_data.get_player().walk_to(Vector2(global_position.x, _player_data.get_position().y))

	# Check if the cover is already removed
	if _cover != null and _cover.freeze:
		_cover.use_parent_material = false
		# Remove the cover
		_cover.freeze = false
		_cover.apply_impulse(Vector2(0, -1500), Vector2(0, 0))
		_cover.constant_torque = (randf_range(5000, 10000) * (1 if randf() > 0.5 else -1))
		# Add the tooltip
		_tooltip.visibility_layer = 1
		# Remove the cover after it leaves the screen
		var visibility_notifier = _cover.get_node("VisibleOnScreenNotifier2D")
		visibility_notifier.connect("screen_exited", _on_cover_exited)
		get_tree().call_group("Telescreen", "queue_content", "Warning")
		return

	# Todo: Chopper death
	

func _on_cover_exited() -> void:
	_cover.queue_free()
