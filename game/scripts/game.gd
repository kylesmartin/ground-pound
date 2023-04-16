class_name Game
extends Node2D

# points scored
var points: int

# runs when the blob gets deflected
func _on_blob_deflected() -> void:
	points += 1
	print("Game._on_blob_deflected: Current score: %d" % points)
