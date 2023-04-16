extends State

# the animated player sprite
@export var animated_sprite: AnimatedSprite2D

func enter(_msg := {}) -> void:
	# upon entering the state, play the walk animation
	# use "flipped" key to get direction
	animated_sprite.play("walk")
	animated_sprite.flip_h = _msg["flipped"]

func update(delta: float) -> void:
	# flip movement based in inputs
	if Input.is_action_just_pressed("move_left"):
		animated_sprite.flip_h = true
	if Input.is_action_just_pressed("move_right"):
		animated_sprite.flip_h = false
	
	# if not moving, transition to idle state
	if !Input.is_action_pressed("move_left") and !Input.is_action_pressed("move_right"):
		state_machine.transition_to("Idle")

func exit() -> void:
	# on exit, stop the current walk animation
	animated_sprite.stop()
