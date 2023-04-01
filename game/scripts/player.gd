class_name Player
extends CharacterBody2D

# movement speed
@export var speed: float = 200
# jump speed
@export var jump_speed: float = 350
# ground pound speed
@export var ground_pound_speed: float = 750
# force of gravity
@export var gravity: float = 200
# increases gravity when player is descending
@export var downwards: float = 1.5

# is player mid ground pound?
var is_ground_pounding: bool = false

# notifies other nodes that ground has been pounded
signal ground_pounded(Vector2)

# TODO: Improve "snappiness" of movement
func _physics_process(delta: float) -> void:
	# apply gravity
	if velocity.y < 0:
		velocity.y += delta * (gravity * 1.5)
	else:
		velocity.y += delta * gravity

	# update horizontal component based on user input
	if Input.is_action_pressed("move_left"):
		velocity.x = -1 * speed
	elif Input.is_action_pressed("move_right"):
		velocity.x = speed
	else:
		velocity.x = 0
	
	# "move_and_slide" already takes delta time into account.
	move_and_slide()
	
	# start jump
	if is_on_floor() and Input.is_action_just_pressed("left_click"):
		velocity.y = -1 * jump_speed
		
	# start ground pound
	if !is_on_floor() and Input.is_action_just_pressed("left_click"):
		velocity.y = ground_pound_speed
		is_ground_pounding = true
		
	# check if player slammed floor
	if is_on_floor() and is_ground_pounding:
		is_ground_pounding = false
		ground_pounded.emit(position)
