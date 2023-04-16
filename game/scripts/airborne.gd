extends State

# the animated player sprite
@export var animated_sprite: AnimatedSprite2D

func enter(_msg := {}) -> void:
	# upon entering the state, play the airborne animation
	# use "flipped" key to get direction
	animated_sprite.play("airborne")

func update(delta: float) -> void:
	# flip movement based in inputs
	if Input.is_action_just_pressed("move_left"):
		animated_sprite.flip_h = true
	if Input.is_action_just_pressed("move_right"):
		animated_sprite.flip_h = false
	
	# transition to idle if on floor
	if get_parent().get_parent().is_on_floor():
		state_machine.transition_to("Idle")

func exit() -> void:
	# on exit, stop the current airborne animation
	animated_sprite.stop()
