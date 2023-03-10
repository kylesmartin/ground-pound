class_name Player
extends CharacterBody2D

# speed multiplier
@export var speed: float = 10.0

func _physics_process(delta):
	# get input and update velocity
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction.normalized() * speed # TODO: * delta
	move_and_slide()
