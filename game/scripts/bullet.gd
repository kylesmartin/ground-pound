class_name Bullet
extends Area2D

var speed: float = 10.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += global_transform.x * speed # TODO: use delta
