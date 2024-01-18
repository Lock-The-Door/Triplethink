extends Node2D

@export var quiz_definition: Array[QuizQuestion]

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var choices_screen: PackedScene = preload("res://templates/choices_screen.tscn")

var question_index = 0
var timer = 10.0
var timer_running = false
var lives = 2
var last_result: QuizAnswer = null
var choice_screen: ChoicesScreen = null

func _process(delta: float) -> void:
	if timer_running:
		timer -= delta
		$Choices/Timer.text = str(int(timer))
		if timer <= 0:
			timer_running = false
			_death_shock(true)
func _on_animation_player_animation_finished(anim_name:StringName) -> void:
	match anim_name:
		"Intro":
			_ask_question()
		"Answering":
			question_index += 1
			print(last_result)
			_brian_say(last_result.comment)
			match last_result.result:
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

		"Release":
			var transition = Transitioner.new(true, "escape")
			add_child(transition)

func _ask_question() -> void:
	if question_index >= quiz_definition.size():
		_release()
		return

	var question = quiz_definition[question_index]

	_brian_say(question.question)

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
	_player_say(result.answer)

func _mini_shock() -> void:
	animation_player.play("Mini Shock")

func _death_shock(is_timeout = false) -> void:
	animation_player.play("Death Shock")
	if is_timeout:
		_brian_say("Too slow")

func _release() -> void:
	animation_player.play("Release")

@onready var _brian_speech = $Brian/Template
var brian_speech_instance = null
func _brian_say(text: String) -> void:
	if brian_speech_instance != null:
		brian_speech_instance.queue_free()
	
	brian_speech_instance = _brian_speech.duplicate()
	brian_speech_instance.text = text
	$Brian.add_child(brian_speech_instance)
	brian_speech_instance.process_mode = Node.PROCESS_MODE_INHERIT
	brian_speech_instance.visible = true
	brian_speech_instance.connect("finished", _speech_finished)

@onready var _player_speech = $Chair/Speech
var player_speech_instance = null
func _player_say(text: String) -> void:
	if player_speech_instance != null:
		player_speech_instance.queue_free()

	player_speech_instance = _player_speech.duplicate()
	player_speech_instance.text = text
	$Chair.add_child(player_speech_instance)
	player_speech_instance.process_mode = Node.PROCESS_MODE_INHERIT
	player_speech_instance.visible = true

	player_speech_instance.connect("finished", _speech_finished)

func _speech_finished(speech: SpeechBubble):
	var delete_timer = Timer.new()
	delete_timer.set_wait_time(1.0)
	delete_timer.set_one_shot(true)
	add_child(delete_timer)
	delete_timer.connect("timeout", speech.queue_free)
	delete_timer.start()

	if speech == brian_speech_instance:
		brian_speech_instance = null
	elif speech == player_speech_instance:
		player_speech_instance = null