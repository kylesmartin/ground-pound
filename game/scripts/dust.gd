class_name Dust
extends Node2D

func _ready() -> void:
	$AnimatedSprite2D.play("poof")

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
