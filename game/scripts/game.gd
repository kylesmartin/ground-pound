class_name Game
extends Node2D

# blob node
@export var blob: Blob
# all intersections as node paths
@export var intersection_paths: Array[NodePath]

# all intersection nodes
var intersections: Array[Intersection]

func _ready() -> void:
	# assemble intersections array
	for path in intersection_paths:
		intersections.append(get_node(path))

# called when blob destroys cylinder
func _on_blob_hit_cylinder(p_intersection: Intersection) -> void:
	if p_intersection not in intersections:
		push_error("game._on_blob_hit_cylinder: intersection not known to game")
	
	# tell each intersection to erase impacted node paths
	for intersection in intersections:
		if intersection == p_intersection:
			continue
		intersection.shut_down_entries(p_intersection.entries)
	
	# erase intersection and cylinder from game
	intersections.erase(p_intersection)
	p_intersection.cylinder.queue_free()
	p_intersection.queue_free()
	
	# respawn blob at first available cylinder (TODO: improve and randomize)
	for intersection in intersections:
		if intersection.cylinder != null:
			blob.paused = false
			blob.current_intersection = null
			blob.switch_path(intersection.entries[0])
			return
	
	print("TODO: GAME OVER!")
