extends State

# the animated player sprite
@export var animated_sprite: AnimatedSprite2D

func enter(_msg := {}) -> void:
	# upon entering the state, play the walk animation
	animated_sprite.play("walk")

func update(delta: float) -> void:
	# if not moving, transition to idle state
	if !Input.is_action_pressed("move_left") and !Input.is_action_pressed("move_right"):
		state_machine.transition_to("Idle")

func exit() -> void:
	# on exit, stop the current walk animation
	animated_sprite.stop()
