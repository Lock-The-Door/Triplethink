extends Interactable

@onready var _cover: RigidBody2D = get_node("Cover")

func _on_clicked() -> void:
	# Check if the cover is already removed
	if _cover != null and _cover.freeze:
		_cover.use_parent_material = false
		# Remove the cover
		_cover.freeze = false
		_cover.apply_impulse(Vector2(0, -1500), Vector2(0, 0))
		_cover.constant_torque = (randf_range(5000, 10000) * (1 if randf() > 0.5 else -1))
		# Remove the cover after it leaves the screen
		var visibility_notifier = _cover.get_node("VisibleOnScreenNotifier2D")
		visibility_notifier.connect("screen_exited", _on_cover_exited)
		
		return

	# Todo: Chopper death
	

func _on_cover_exited() -> void:
	_cover.queue_free()
