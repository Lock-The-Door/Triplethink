extends Interactable

@onready var death_anim: AnimationPlayer = $AnimationPlayer
@onready var _player_data: PlayerData = get_node("/root/PlayerData")

func _on_clicked() -> void:
    death_anim.play("left_death")
    _player_data.get_player().process_mode = Node.PROCESS_MODE_DISABLED