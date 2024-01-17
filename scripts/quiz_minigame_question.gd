class_name QuizQuestion
extends Resource

@export var question: String
@export var question_visual: Texture
@export_group("Answers")
@export var answer_a: QuizAnswer
@export var answer_b: QuizAnswer
@export var answer_c: QuizAnswer
@export var answer_d: QuizAnswer

func get_result(answer: String) -> QuizAnswer.AnswerResult:
    if answer == answer_a.answer:
        return answer_a.result
    elif answer == answer_b.answer:
        return answer_b.result
    elif answer == answer_c.answer:
        return answer_c.result
    elif answer == answer_d.answer:
        return answer_d.result

    return QuizAnswer.AnswerResult.DEATH_SHOCK