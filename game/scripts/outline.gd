class_name Outline
extends Node2D

@onready var intersection_name: String = get_parent().name

func _ready():
	off()

func shine() -> void:
	$OutlineOnSound.play()
	$AnimatedSprite2D.play("%s_on" % intersection_name)

func off() -> void:
	$AnimatedSprite2D.play("%s_off" % intersection_name)
