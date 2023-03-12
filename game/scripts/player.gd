class_name Player
extends CharacterBody2D

# movement speed
@export var speed: float = 10000
# seconds between shots
@export var seconds_between_shots: float = 0.1 
# bullet scene, instantiated when shot
@onready var bullet: PackedScene = preload("res://scenes/bullet.tscn")

# time since last bullet was shot
var time_since_last_shot: float = seconds_between_shots

func _physics_process(delta: float) -> void:
	# get input and update velocity
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction.normalized() * speed * delta
	move_and_slide()

func _process(delta: float) -> void:
	# increment time since last shot
	time_since_last_shot += delta
	
	# shoot when left mouse button is clicked
	if Input.is_action_just_pressed("left_click"):
		shoot()

# instantiate and shoot bullet
func shoot() -> void:
	# check if sufficient time passed since last shot
	if (time_since_last_shot < seconds_between_shots):
		return

	# instantiate bullet and add to game scene
	var bullet_instance: Node = bullet.instantiate()
	get_parent().add_child(bullet_instance)
	# set bullet position to player position and bullet rotation to look at mouse
	bullet_instance.position = position
	bullet_instance.look_at(get_global_mouse_position())
	# reset time since last shot
	time_since_last_shot = 0
