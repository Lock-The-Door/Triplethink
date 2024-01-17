class_name ChoicesScreen
extends Panel

@export var question_text: String = "Which option do you like the most?"
@export var question_texture: Texture = null
@export var shuffle_options: bool = true
@export_group("Options")
@export var option_a: String = "Option A"
@export var option_b: String = "Option B"
@export var option_c: String = "Option C"
@export var option_d: String = "Option D"

@onready var _options = [option_a, option_b, option_c, option_d]

signal answer_selected(answer: String)

func _ready() -> void:
	if question_texture != null:
		$Question/Question/VBoxContainer/QuestionImage.texture = question_texture
	$Question/VBoxContainer/QuestionLabel.text = question_text
	if shuffle_options:
		_options.shuffle()
	$"Choices/Option A".text = _options[0]
	$"Choices/Option B".text = _options[1]
	$"Choices/Option C".text = _options[2]
	$"Choices/Option D".text = _options[3]


func _on_option_a_pressed() -> void:
	answer_selected.emit(_options[0])

func _on_option_b_pressed() -> void:
	answer_selected.emit(_options[1])

func _on_option_c_pressed() -> void:
	answer_selected.emit(_options[2])

func _on_option_d_pressed() -> void:
	answer_selected.emit(_options[3])
