class_name Intersection
extends Area2D

# defines each type of intersection entry
enum EntryType {ARROW, TAIL}

# stores node paths of each intersecting path
@export var paths: Array[NodePath]
# stores entry type of each intersecting path
@export var types: Array[EntryType]
# is platform node enabled for this intersection?
@export var platform_enabled: bool = true

@onready var platform = $Platform

# represents entry to intersection
class Entry:
	var path: Node
	var type: EntryType
	
	func init(p_path: Node, p_type: EntryType):
		path = p_path
		type = p_type

# generates random numbers
var rng = RandomNumberGenerator.new()
# stores all entries to intersection
var entries: Array[Entry]

func _ready() -> void:
	# disable platform
	if !platform_enabled:
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

# gets entry given path
func get_entry(path: Node) -> Entry:
	for entry in entries:
		if path.name == entry.path.name:
			return entry
	return null

# gets random entry given current path
func get_next_path(current_path: Node) -> Entry:
	var current_entry: Entry = get_entry(current_path)
	
	# error if current path is not part of intersection
	if current_entry == null:
		push_error("Intersection.get_next_path: intersection does not contain current_path")
		return null
	
	# remove current path from options
	var avail_entries: Array[Entry] = entries.duplicate()
	avail_entries.erase(current_entry)
	# select random path
	var rand_int: int = rng.randi_range(0, len(avail_entries)-1)
	return avail_entries[rand_int]

# sets current intersection on blob
func _on_area_entered(area):
	var blob: Blob = area.get_parent() as Blob
	if blob == null:
		return
		
	blob.set_intersection(self)
