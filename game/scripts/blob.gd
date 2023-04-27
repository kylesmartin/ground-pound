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
# did the blob just switch paths?
var just_switched: bool = false

# emitted when blob gets deflected
signal deflected()
# emitted when blob hits a platform
signal hit()

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
		# if platform enabled, divide speed by multiplier and turn on platform light
		if current_intersection.platform_enabled:
			hit.emit()
			current_speed = max(current_speed / speed_multiplier, start_speed)
			current_intersection.platform.shine()
			current_intersection.outline.off()
		
		# get the next entry
		var next_entry: Intersection.Entry = current_intersection.get_next_path(get_parent())
		
		# set new parent
		raise_just_switched()
		get_parent().remove_child(self)
		next_entry.path.add_child(self)
		
		# set progress ratio based on type
		if (next_entry.type == Intersection.EntryType.ARROW):
			progress_ratio = 1
			direction = -1
		else:
			progress_ratio = 0
			direction = 1

# used to help other components know if the blob just switched paths
func raise_just_switched() -> void:
	just_switched = true
	await get_tree().create_timer(0.1).timeout
	just_switched = false

# sets current intersection of blob
func set_intersection(new_intersection: Intersection) -> void:
	current_intersection = new_intersection

# deflects the blob
func _on_player_ground_pounded(intersection: Intersection) -> void:
	# return if the current intersection is null, is not the intersection that got pounded, or has no platform
	if current_intersection == null or current_intersection != intersection or !current_intersection.platform_enabled:
		return
	
	# verify that blob is approaching the center of the current intersection before deflecting
	if (progress_ratio > 0.5 and direction == 1) or (progress_ratio < 0.5 and direction == -1):
		# flip direction and increment speed
		direction = direction * -1
		current_speed *= speed_multiplier
		# emit deflected signal
		deflected.emit()
		current_intersection.outline.off()
