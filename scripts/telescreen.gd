class_name Telescreen
extends Node2D

@onready var available_content: Node = get_node("Viewports")
@onready var current_content: Sprite2D = get_node("Frame/Content")
@onready var content_texture: ViewportTexture = current_content.texture

var queue := []
var content_running := false
var current_player: Object = null

var slogan_timer := 0.0

func _process(delta: float) -> void:
    if content_running:
        return

    slogan_timer += delta

    if slogan_timer > 15.0:
        slogan_timer = 0.0
        queue_content("Slogan")

    if queue.size() > 0:
        content_running = true
        var content_path: String = "Viewports/" + queue.pop_front()
        content_texture.viewport_path = content_path
        var player: AnimationPlayer = get_node(content_path).get_child(0).get_node_or_null("AnimationPlayer")
        if player != null:
            player.play("default")
            player.connect("animation_finished", _on_content_finished)
            current_player = player
        else:
            current_player = Timer.new()
            current_player.set_wait_time(5.0)
            current_player.connect("timeout", _on_content_finished)

        
func queue_content(content: String) -> void:
    queue.append(content)

func _on_content_finished(_arg) -> void:
    content_running = false
    content_texture.viewport_path = "Viewports/Big Brother"
    if current_player is AnimationPlayer:
        current_player.disconnect("animation_finished", _on_content_finished)
    else:
        current_player.disconnect("timeout", _on_content_finished)