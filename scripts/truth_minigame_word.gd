class_name TruthWord
extends Label

var normal_settings = preload("res://resources/truth_text_label_settings.tres")
var banned_settings = preload("res://resources/false_text_label_settings.tres")

var is_banned = false
var hovered = false
var visibility_notifier = null

signal word_corrected
signal word_missed
signal word_miscorrected

func _init(word: String, banned: bool) -> void:
    set_text(word + " ")
    mouse_filter = Control.MOUSE_FILTER_STOP

    is_banned = banned

    if banned:
        label_settings = banned_settings
    else:
        label_settings = normal_settings

    mouse_entered.connect(_on_mouse_entered)
    mouse_exited.connect(_on_mouse_exited)

func _ready() -> void:
    if is_banned:
        visibility_notifier = VisibleOnScreenNotifier2D.new()
        visibility_notifier.rect.size = size
        add_child(visibility_notifier)
        visibility_notifier.connect("screen_exited", _on_screen_exited)

func _on_screen_exited() -> void:
    if is_banned:
        word_missed.emit(self)

func _on_mouse_entered() -> void:
    modulate = Color(1, 0.5, 0.5, 1)
    hovered = true

func _on_mouse_exited() -> void:
    modulate = Color(1, 1, 1, 1)
    hovered = false

func _input(event: InputEvent) -> void:
    if not hovered:
        return
    if event is InputEventMouseButton:
        var mouse_event = event as InputEventMouseButton
        if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
            if is_banned:
                word_corrected.emit(self)
                label_settings = normal_settings
                if visibility_notifier != null:
                    visibility_notifier.queue_free()
            else:
                word_miscorrected.emit(self)