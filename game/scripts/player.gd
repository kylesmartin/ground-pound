class_name Player
extends CharacterBody2D

# speed multiplier
@export var speed: float = 10.0

@onready var bullet = preload("res://scenes/bullet.tscn")

func _physics_process(delta):
	# get input and update velocity
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction.normalized() * speed # TODO: * delta
	move_and_slide()

func _process(delta):
	if Input.is_action_just_pressed("left_click"):
		shoot()

func shoot():
	var bullet_instance = bullet.instantiate()
	get_parent().add_child(bullet_instance)
	bullet_instance.position = position
	bullet_instance.look_at(get_global_mouse_position())
