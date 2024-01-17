class_name QuizAnswer
extends Resource

enum AnswerResult {
    NONE,
    CORRECT,
    MINI_SHOCK,
    DEATH_SHOCK
}

@export var answer: String
@export var result: AnswerResult
@export var comment: String