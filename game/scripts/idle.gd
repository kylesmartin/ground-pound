extends State

# the animated player sprite
@export var animated_sprite: AnimatedSprite2D

func enter(_msg := {}) -> void:
	# upon entering the state, play the idle animation
	animated_sprite.play("idle")

func update(delta: float) -> void:
	# if moving, transition to the walk state
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		state_machine.transition_to("Walk")

func exit() -> void:
	# on exit, stop the current idle animation
	animated_sprite.stop()
