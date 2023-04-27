class_name Platform
extends StaticBody2D

# how long does the shine last
const shine_duration_seconds: float = 2

# Called when the node enters the scene tree for the first time.
func shine() -> void:
	$AnimatedSprite2D.play("on")
	$PlatformOnSound.play()
	await get_tree().create_timer(shine_duration_seconds).timeout
	$AnimatedSprite2D.play("off")
