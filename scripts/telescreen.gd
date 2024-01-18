class_name Telescreen
extends Node2D

@onready var available_content: Node = get_node("Viewports")
@onready var current_content: Sprite2D = get_node("Frame/Content")
@onready var content_texture: ViewportTexture = current_content.texture
@onready var frame: Sprite2D = get_node("Frame")

var queue := []
var content_running := false
var current_player: Object = null
var current_bubble: SpeechBubble = null

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
		var speech_bubble: SpeechBubble = get_node_or_null(content_path + "/SpeechBubble")
		if speech_bubble != null:
			current_bubble = speech_bubble.duplicate()
			add_child(current_bubble)
			current_bubble.position = Vector2(0, -200)
			current_bubble.visible = true
			current_bubble.process_mode = Node.ProcessMode.PROCESS_MODE_PAUSABLE
			current_bubble.position.x -= current_bubble.size.x / 2

		var player: AnimationPlayer = get_node(content_path).get_child(0).get_node_or_null("AnimationPlayer")
		if player != null:
			player.play("default")
			player.connect("animation_finished", _on_content_finished)
			current_player = player
		else:
			var wait = 5.0
			if speech_bubble != null:
				wait = speech_bubble.get_node("Bubble/Text").get_text().length() / speech_bubble.characters_per_second + 3
			current_player = Timer.new()
			current_player.connect("timeout", _on_content_finished)
			add_child(current_player)
			current_player.start(wait)

		
func queue_content(content: String) -> void:
	queue.append(content)

func _on_content_finished(_arg = null) -> void:
	content_running = false
	content_texture.viewport_path = "Viewports/Big Brother"
	if current_player is AnimationPlayer:
		current_player.disconnect("animation_finished", _on_content_finished)
	else:
		current_player.disconnect("timeout", _on_content_finished)
		current_player.queue_free()

	if current_bubble != null:
		current_bubble.queue_free()
		current_bubble = null
