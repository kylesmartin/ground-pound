class_name Blob
extends PathFollow2D

# player
@export var player: Player
# starting movement speed
@export var start_speed: float = 100
# proximity to platform that enables deflection
@export var threshold: float = 10
# post-deflection speed multiplier
@export var speed_multiplier: float = 1.5

# movement direction along current path
var direction: int = 1
# current intersection that blob has reached
var current_intersection: Intersection
# tracks the current speed of the blob
var current_speed: float = start_speed

# emitted when blob gets deflected
signal deflected()

func _ready() -> void:
	# connect to player's ground pound signal
	if player == null:
		push_error("Blob._ready: no player found")
	else:
		player.ground_pounded.connect(_on_player_ground_pounded.bind())

func _physics_process(delta: float) -> void:
	# move along path
	progress += direction * current_speed * delta
	
	# change path if reached end of current one
	if ((progress_ratio == 1 and direction == 1) or (progress_ratio == 0 and direction == -1)):
		# reset speed if platform is hit
		if (current_intersection.platform != null):
			current_speed = start_speed
		
		# get next entry
		var next_entry: Intersection.Entry = current_intersection.get_next_path(get_parent())

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
func _on_player_ground_pounded(player_position: Vector2) -> void:
	# return if current intersection is not within threshold
	if (player_position - position).length() > threshold:
		return
	
	# check if blob is in edge quadrant and facing nearby intersection
	if (progress_ratio > 0.75 and direction == 1) or (progress_ratio < 0.25 and direction == -1):
		# change direction and increment speed
		direction = direction * -1
		current_speed *= speed_multiplier
		# emit deflected signal
		deflected.emit()
