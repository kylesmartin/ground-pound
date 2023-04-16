extends State

# the animated player sprite
@export var animated_sprite: AnimatedSprite2D

func _ready() -> void:
	animated_sprite.animation_finished.connect(_on_animation_finished.bind())

func enter(_msg := {}) -> void:
	# upon entering the state, play the jump animation
	animated_sprite.play("jump")

func exit() -> void:
	# on exit, stop the current jump animation
	animated_sprite.stop()
	
func _on_animation_finished() -> void:
	if !is_active:
		return
	
	# transition to airborne when animation completes
	state_machine.transition_to("Airborne")
