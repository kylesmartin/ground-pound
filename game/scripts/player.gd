class_name Player
extends CharacterBody2D

# movement speed
@export var speed: float = 200
# jump speed
@export var jump_speed: float = 350
# ground pound speed
@export var ground_pound_speed: float = 750
# force of gravity
@export var gravity_force: float = 200
# increases gravity when player is descending
@export var downwards: float = 1.5
# max velocity
@export var terminal_velocity: float = 500
# this player's state machine
@export var state_machine: StateMachine

# dust scene, spawned during jumps and lands
var dust_scene: PackedScene = preload("res://scenes/dust.tscn")
# is the player mid ground pound?
var is_ground_pounding: bool = false
# was the player on the floor in the previous frame?
var prev_on_floor: bool = false
# all possible intersections
var intersections: Array[Intersection]

# the player will never be this far from a platform
const unreachable_distance = 1000000

# notifies other nodes that the ground has been pounded
signal ground_pounded(Intersection)

func _ready() -> void:
	# store intersections with platforms
	for child in get_parent().get_children():
		# only children to Game of class Area2D are Intersections
		# TODO: this is not ideal if other Area2Ds are added as direct children
		if child.is_class("Area2D") and (child as Intersection).platform_enabled:
			intersections.push_back(child)

# get the nearest intersection to the player
func get_nearest_intersection() -> Intersection:
	var nearest_intersection: Intersection = null
	var nearest_distance: float = unreachable_distance
	
	for intersection in intersections:
		# compare to the running nearest distance
		# update the nearest intersection if needed
		var distance = (intersection.position - position).length()
		if distance < nearest_distance:
			nearest_distance = distance
			nearest_intersection = intersection
	
	return nearest_intersection

# spawns a dust scene
func spawn_dust() -> void:
	var dust_instance: Dust = dust_scene.instantiate() as Dust
	dust_instance.position = position - Vector2(0, 16) # dust offsets by 16 pixels
	get_parent().add_child(dust_instance)

func _physics_process(delta: float) -> void:
	# apply gravity
	if velocity.y > 0:
		# increase gravity if velocity is negative
		velocity.y += (gravity_force * downwards)
	else:
		velocity.y += gravity_force
	
	# velocity can only become so large
	velocity.y = min(terminal_velocity, velocity.y)
	
	# update horizontal component based on user input
	if Input.is_action_pressed("move_left"):
		velocity.x = -1 * speed
		$AnimatedSprite2D.flip_h = true
	elif Input.is_action_pressed("move_right"):
		velocity.x = speed
		$AnimatedSprite2D.flip_h = false
	else:
		velocity.x = 0
	
	# "move_and_slide" already takes delta time into account.
	move_and_slide()
	
	if !is_on_floor() and (state_machine.current_state_name != "Jump"):
		state_machine.transition_to("Airborne")
	
	# start ground pound
	if !is_on_floor() and Input.is_action_just_pressed("ground_pound"):
		state_machine.transition_to("Jump")
		$TriggerPoundSound.play()
		velocity.y = ground_pound_speed
		is_ground_pounding = true
	
	# if the player just landed, spawn dust
	if is_on_floor() and !prev_on_floor:
		state_machine.transition_to("Land")
		spawn_dust() 
	
	# check if the player just ground-pounded
	if is_on_floor() and is_ground_pounding:
		is_ground_pounding = false
		$PoundSound.play()
		# using colliders to update the nearest intersection does not work every time
		# sometimes, there is a delay in the update and the signal emits null
		# to fix, we get the nearest intersection whenever the ground pound occurs
		ground_pounded.emit(get_nearest_intersection())
	elif is_on_floor() and !prev_on_floor:
		$LandSound.play()
	
	# start jump
	if is_on_floor() and Input.is_action_just_pressed("move_up"):
		state_machine.transition_to("Jump")
		$JumpSound.play()
		velocity.y = -1 * jump_speed
		spawn_dust()
	
	prev_on_floor = is_on_floor()
