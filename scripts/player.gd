class_name Player
extends CharacterBody2D

enum ControlScheme {
	ARROWS,
	WASD
}

@export var platforming_enabled: bool = false
@export var player_speed: int = 300
@export var gravity: int = 1000

@onready var _player_data: PlayerData = get_node("/root/PlayerData")

var _control_scheme := ControlScheme.ARROWS
@onready var _override_target: Vector2 = global_position

func _ready() -> void:
	change_controls(_control_scheme)
	_player_data.update_position(global_position)
	_player_data.update_active_player(self)

func _physics_process(delta: float) -> void:
	if _override_target != global_position:
		velocity = (_override_target - position).normalized() * player_speed
		if _override_target.distance_to(global_position) < 1:
			_override_target = global_position
			velocity = Vector2.ZERO
	elif platforming_enabled:
		velocity.x = 0
		velocity.y += gravity * delta
		
		if Input.is_action_pressed("move_left"):
			velocity.x = -player_speed
		elif Input.is_action_pressed("move_right"):
			velocity.x = player_speed
		if Input.is_action_pressed("move_jump"):
			velocity.y = -gravity

		_override_target = global_position + velocity * delta

	move_and_slide()
	_player_data.update_position(global_position)

func change_controls(scheme: ControlScheme) -> void:
	_control_scheme = scheme
	
	InputMap.action_erase_events("move_left")
	InputMap.action_erase_events("move_right")
	InputMap.action_erase_events("move_jump")
	
	match scheme:
		ControlScheme.ARROWS:
			var left = InputEventKey.new()
			left.keycode = KEY_LEFT
			InputMap.action_add_event("move_left", left)
			var right = InputEventKey.new()
			right.keycode = KEY_RIGHT
			InputMap.action_add_event("move_right", right)
			var jump = InputEventKey.new()
			jump.keycode = KEY_UP
			InputMap.action_add_event("move_jump", jump)
		ControlScheme.WASD:
			var left = InputEventKey.new()
			left.keycode = KEY_A
			InputMap.action_add_event("move_left", left)
			var right = InputEventKey.new()
			right.keycode = KEY_D
			InputMap.action_add_event("move_right", right)
			var jump = InputEventKey.new()
			jump.keycode = KEY_W
			InputMap.action_add_event("move_jump", jump)

func walk_to(direction: Vector2) -> void:
	_override_target = direction