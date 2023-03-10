class_name Blob
extends PathFollow2D

# speed multiplier
@export var speed: float = 1

# movement direction along path
var direction: int = 1
# current intersection that blob has reached
var current_intersection: Intersection

func _physics_process(delta):
	# move along path
	progress += direction * speed # TODO: * delta
	
	# change path if reached end of current one
	if ((progress_ratio == 1 and direction == 1) or (progress_ratio == 0 and direction == -1)):
		var current_path = get_parent()
		var next_entry: Intersection.Entry = current_intersection.get_next_path(current_path)
		# switch parent of blob
		current_path.remove_child(self)
		next_entry.path.add_child(self)
		# set progress based on type
		if (next_entry.type == Intersection.EntryType.ARROW):
			progress_ratio = 1
			direction = -1
		else:
			progress_ratio = 0
			direction = 1

# sets the current intersection of blob
func set_intersection(new_intersection: Intersection):
	current_intersection = new_intersection
