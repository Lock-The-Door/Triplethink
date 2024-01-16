class_name TwoMinutesHate
extends Control

@onready var rules := get_node("Person/Rules")
@onready var big_brother_pic := get_node("Person/BB")
@onready var goldstein_pic := get_node("Person/Goldstein")

@onready var score_label: Label = get_node("Score")
@onready var score_progress: ProgressBar = get_node("ScoreBar")
@onready var timer_label: Label = get_node("Timer")
@onready var timer_progress: ProgressBar = get_node("TimerBar")

var started = false
var score = 0
var timer = 120.0
var current_pic = 0 # 0 = none, 1 = big brother, 2 = goldstein
var _switch_elapsed = 0.0
var _next_switch = 5.0

func _process(delta: float) -> void:
	if started:
		_switch_elapsed += delta
		timer -= delta
		## convert to m:ss
		var minutes = int(timer / 60)
		var seconds = int(timer) % 60
		timer_label.text = str(minutes) + ":" + str(seconds).pad_zeros(2)
		timer_progress.value = timer

		if _switch_elapsed >= _next_switch:
			_switch_elapsed = 0.0
			_next_switch = randf_range(3.0, 10.0)
			_swap_pics()

		if timer <= 0.0:
			started = false
			# todo: game over

func _on_start_button_pressed() -> void:
	started = true
	rules.queue_free()
	_swap_pics()

func _swap_pics() -> void:
	if current_pic < 2:
		current_pic += 1
	else:
		current_pic = 1

	if current_pic == 1:
		big_brother_pic.show()
		goldstein_pic.hide()
	elif current_pic == 2:
		big_brother_pic.hide()
		goldstein_pic.show()
	else:
		big_brother_pic.hide()
		goldstein_pic.hide()

func player_input (is_hate: bool):
	if not started:
		return
	if (not is_hate and current_pic == 1) or (is_hate and current_pic == 2):
		_update_score(1)
	else:
		_update_score(-10)

func _update_score(delta_score: int) -> void:
	score += delta_score
	score_label.text = "Score: " + str(score)
	score_progress.value = score