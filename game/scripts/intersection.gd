class_name Intersection
extends Area2D

# defines each type of intersection entry
enum EntryType {ARROW, TAIL}

# stores the node paths of each intersecting path
@export var paths: Array[NodePath]
# stores the entry type of each intersecting path
@export var types: Array[EntryType]
# is the platform node enabled for this intersection?
@export var platform_enabled: bool = true

# represents an entry to this intersection
class Entry:
	var path: Node
	var type: EntryType
	
	func init(p_path: Node, p_type: EntryType):
		path = p_path
		type = p_type

# the platform node corresponding to this intersection
@onready var platform = $Platform
# generates random numbers
var rng = RandomNumberGenerator.new()
# stores all entries to intersection
var entries: Array[Entry]

func _ready() -> void:
	if !platform_enabled:
		# disable platform
		platform.queue_free()
		platform = null
		
	# paths and types must be of equal sizes to build entry objects
	if paths.size() != types.size():
		push_error("Intersection._ready: paths and entry_types must be of equal size")	
	
	# build one entry object for each intersecting path
	for i in paths.size():
		var entry: Entry = Entry.new()
		entry.init(get_node(paths[i]), types[i])
		entries.append(entry)

# gets the corresponding entry given a path
func get_entry(path: Node) -> Entry:
	for entry in entries:
		if path.name == entry.path.name:
			return entry
	return null

# gets a random entry given the current path
func get_next_path(current_path: Node) -> Entry:
	var current_entry: Entry = get_entry(current_path)
	
	# error if the current path is not part of this intersection
	if current_entry == null:
		push_error("Intersection.get_next_path: intersection does not contain current_path")
		return null
	
	# remove the current path from available options for next path
	var avail_entries: Array[Entry] = entries.duplicate()
	avail_entries.erase(current_entry)
	# select a random next path
	var rand_int: int = rng.randi_range(0, len(avail_entries)-1)
	return avail_entries[rand_int]



# sets the current intersection on the blob
func _on_area_entered(area) -> void:
	var blob: Blob = area.get_parent() as Blob
	if blob == null:
		return
		
	blob.set_intersection(self)

# unsets the current intersection on the blob
func _on_area_exited(area) -> void:
	var blob: Blob = area.get_parent() as Blob
	if blob == null:
		return
		
	blob.set_intersection(null)

# slows down blob and notifies blob of the hitbox
func _on_hitbox_area_entered(area) -> void:
	var blob: Blob = area.get_parent() as Blob
	if blob == null or !platform_enabled:
		return
	
	blob.in_hitbox = true
	blob.reset_speed()


# lowers the hitbox flag
func _on_hitbox_area_exited(area) -> void:
	var blob: Blob = area.get_parent() as Blob
	if blob == null or !platform_enabled:
		return
	
	blob.in_hitbox = false

# set intersection on player
func _on_body_entered(body) -> void:
	var player: Player = body as Player
	if player == null or !platform_enabled:
		return
	
	player.set_intersection(self)
