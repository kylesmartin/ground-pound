class_name Bullet
extends Area2D

# movement speed
var speed: float = 900

func _physics_process(delta: float) -> void:
	# move bullet at constant velocity
	position += global_transform.x * speed * delta

# called when body enters bullet's area
func _on_body_entered(body):
	var player: Player = body as Player
	var cylinder: Cylinder = body as Cylinder
	
	# return if body is player
	if player != null:
		return
	
	# emit signal if cylinder is shot
	if cylinder != null:
		cylinder.shot.emit(position)
	
	# destroy the bullet
	queue_free()
