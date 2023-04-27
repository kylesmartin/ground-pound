extends Node2D

# the y value at which to spawn the player when they go out of zone
@export var y_spawn: float = -100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_zone_body_exited(body):
	body.position = Vector2(body.position.x, y_spawn)
