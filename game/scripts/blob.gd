class_name Blob
extends PathFollow2D

# starting movement speed
@export var speed: float = 10000
# proximity to cylinder that enables deflection
@export var threshold: float = 10
# post-deflection speed multiplier
@export var speed_multiplier: float = 1.5

# movement direction along current path
var direction: int = 1
# current intersection that blob has reached
var current_intersection: Intersection
# pauses physics process loop
var paused: bool = false

# emitted when blob hits cylinder at intersection
signal hit_cylinder(intersection: Intersection)

func _physics_process(delta: float) -> void:
	# do not proceed if paused
	if paused:
		return
	
	# move along path
	progress += direction * speed * delta
	
	# change path if reached end of current one
	if ((progress_ratio == 1 and direction == 1) or (progress_ratio == 0 and direction == -1)):
		# pause loop and emit signal if cylinder has been hit
		if (current_intersection.cylinder != null):
			paused = true
			hit_cylinder.emit(current_intersection)
			return
		
		# switch to next path
		var next_entry: Intersection.Entry = current_intersection.get_next_path(get_parent())
		switch_path(next_entry)

# switches to next path
func switch_path(next_entry: Intersection.Entry) -> void:
	# switch parent of blob
	get_parent().remove_child(self)
	next_entry.path.add_child(self)
	
	# set progress based on type
	if (next_entry.type == Intersection.EntryType.ARROW):
		progress_ratio = 1
		direction = -1
	else:
		progress_ratio = 0
		direction = 1

# sets current intersection of blob
func set_intersection(new_intersection: Intersection) -> void:
	current_intersection = new_intersection

# deflect blob
func _on_cylinder_shot(cylinder_position: Vector2) -> void:
	# return if current intersection doesn't have cylinder or is not within threshold
	if current_intersection.cylinder == null or (cylinder_position - position).length() > threshold:
		return
	
	# check if blob is in edge quadrant and facing nearby intersection
	if (progress_ratio > 0.75 and direction == 1) or (progress_ratio < 0.25 and direction == -1):
		# change direction and increment speed
		direction = direction * -1
		speed *= speed_multiplier
