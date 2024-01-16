extends Interactable

@export var is_hate = false

@onready var game: TwoMinutesHate = get_node("%TwoMinutesHate")

func _on_clicked () -> void:
    game.player_input(is_hate)