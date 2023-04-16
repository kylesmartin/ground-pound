class_name Blob
extends PathFollow2D

# reference to the player node
@export var player: Player
# initial speed of the blob
@export var start_speed: float = 10
# post-deflection speed multiplier
@export var speed_multiplier: float = 1.5

# movement direction along the current path
var direction: int = 1
# current intersection that the blob is occupying
var current_intersection: Intersection
# tracks the current speed of the blob
var current_speed: float = start_speed
# is the current blob in a platform hitbox?
var in_hitbox: bool = false

# emitted when blob gets deflected
signal deflected()

func _ready() -> void:
	# initialize the current blob speed
	current_speed = start_speed
	# connect to the player's ground pound signal
	if player == null:
		push_error("Blob._ready: no player found")
	else:
		player.ground_pounded.connect(_on_player_ground_pounded.bind())

func _physics_process(delta: float) -> void:
	# move along the current path
	progress += direction * current_speed * delta
	
	# change path if the end of the current path has been reached
	if ((progress_ratio == 1 and direction == 1) or (progress_ratio == 0 and direction == -1)):
		# get the next entry
		var next_entry: Intersection.Entry = current_intersection.get_next_path(get_parent())

		# switch parent
		get_parent().remove_child(self)
		next_entry.path.add_child(self)
		
		# set progress ratio based on type
		if (next_entry.type == Intersection.EntryType.ARROW):
			progress_ratio = 1
			direction = -1
		else:
			progress_ratio = 0
			direction = 1

# sets current intersection of blob
func set_intersection(new_intersection: Intersection) -> void:
	current_intersection = new_intersection

# resets the current speed to the start speed
func reset_speed() -> void:
	current_speed = start_speed

# deflects the blob
func _on_player_ground_pounded(intersection: Intersection) -> void:
	# return if the current intersection is null, has no platform, or is occupying a hitbox
	if current_intersection == null or current_intersection != intersection or !current_intersection.platform_enabled or in_hitbox:
		return
	
	# verify that blob is approaching the center of the current intersection before deflecting
	if (progress_ratio > 0.5 and direction == 1) or (progress_ratio < 0.5 and direction == -1):
		# flip direction and increment speed
		direction = direction * -1
		current_speed *= speed_multiplier
		# emit deflected signal
		deflected.emit()
