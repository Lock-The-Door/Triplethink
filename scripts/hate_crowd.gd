extends Sprite2D

@onready var game: TwoMinutesHate = get_node("%TwoMinutesHate")
@onready var heart_particles: CPUParticles2D = get_node("Hearts")
@onready var hate_particles: CPUParticles2D = get_node("Hates")

func _process(_delta: float) -> void:
	if game.current_pic == 1:
		heart_particles.emitting = true
		hate_particles.emitting = false
	elif game.current_pic == 2:
		heart_particles.emitting = false
		hate_particles.emitting = true
