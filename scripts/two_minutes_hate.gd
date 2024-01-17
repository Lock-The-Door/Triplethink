extends Node2D

@onready var _player_data: PlayerData = get_node("/root/PlayerData")

func _on_two_minutes_hate_game_over(score:int) -> void:
    var player: Player = _player_data.get_player()
    var animation: AnimationPlayer = player.get_node("AnimationPlayer")

    if score > 200:
        animation.play("win")
        player.walk_to(Vector2(1000, player.get_position().y))
        var transition: Transitioner = Transitioner.new(true, "escape")
        add_child(transition)
    else:
        animation.play("lose")
        animation.connect("animation_finished", _on_animation_player_animation_finished)


func _on_animation_player_animation_finished(animation_name: String) -> void:
    var transition: Transitioner = Transitioner.new(true, "electric_chair")
    add_child(transition)

