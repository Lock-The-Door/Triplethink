extends Node2D

@export var quiz_definition: Array[QuizQuestion]

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var choices_screen: PackedScene = preload("res://templates/choices_screen.tscn")

var question_index = 0
var timer = 10.0
var timer_running = false
var lives = 2
var last_result: QuizAnswer.AnswerResult = QuizAnswer.AnswerResult.NONE
var choice_screen: ChoicesScreen = null

func _process(delta: float) -> void:
	if timer_running:
		timer -= delta
		$Choices/Timer.text = str(timer)
		if timer <= 0:
			timer_running = false
			_death_shock()
func _on_animation_player_animation_finished(anim_name:StringName) -> void:
	match anim_name:
		"Intro":
			_ask_question()
		"Answering":
			question_index += 1
			print(last_result)
			match last_result:
				QuizAnswer.AnswerResult.CORRECT:
					if question_index >= quiz_definition.size():
						_release()
					else:
						_ask_question()
				QuizAnswer.AnswerResult.MINI_SHOCK:
					if lives > 1:
						_mini_shock()
					else:
						_death_shock()
				QuizAnswer.AnswerResult.DEATH_SHOCK:
					_death_shock()
				QuizAnswer.AnswerResult.NONE:
					print("Unexpected Behaviour")

		"Mini Shock":
			_ask_question()

		"Death Shock":
			# End game
			pass

func _ask_question() -> void:
	var question = quiz_definition[question_index]

	# Skip this for now, prioritize the choices screen
	# var speech_bubble_instance = $Brian/Template.duplicate()
	# speech_bubble_instance.text = question.question
	# $Brian.add_child(speech_bubble_instance)

	var choices_screen_instance = choices_screen.instantiate()
	choices_screen_instance.question_text = question.question
	choices_screen_instance.question_texture = question.question_visual
	choices_screen_instance.option_a = question.answer_a.answer
	choices_screen_instance.option_b = question.answer_b.answer
	choices_screen_instance.option_c = question.answer_c.answer
	choices_screen_instance.option_d = question.answer_d.answer
	choices_screen_instance.connect("answer_selected", _on_answer_selected)
	$Choices.add_child(choices_screen_instance)
	choice_screen = choices_screen_instance

	animation_player.play("Asking")
	timer = 10
	timer_running = true

func _on_answer_selected(answer: String) -> void:
	timer_running = false
	choice_screen.queue_free()
	print(answer)

	var question = quiz_definition[question_index]
	var result = question.get_result(answer)
	last_result = result
	animation_player.play("Answering")

func _mini_shock() -> void:
	animation_player.play("Mini Shock")

func _death_shock() -> void:
	animation_player.play("Death Shock")

func _release() -> void:
	pass