extends Control

@export var game_over_message = "Game Over!"

@onready var game_over_label = $GameOverLabel

func _ready():
    game_over_label.text = game_over_message