class_name Intersection
extends Area2D

# defines type of entry facing intersection
enum EntryType {ARROW, TAIL}

# stores node paths of each intersecting path
@export var paths: Array[NodePath]
# stores entry type of each intersecting path
@export var types: Array[EntryType]

# represents an entry to intersection via path node and entry type
class Entry:
	var path: Node
	var type: EntryType
	
	func init(p_path: Node, p_type: EntryType):
		path = p_path
		type = p_type

# used to generate random numbers
var rng = RandomNumberGenerator.new()
# stores all entries to intersection with required info
var entries: Array[Entry]

func _ready():
	# must be of equal sizes to build Entry objects
	if paths.size() != types.size():
		push_error("Intersection._ready: paths and entry_types must be of equal size")	
	
	# build one Entry object for each intersecting path
	for i in paths.size():
		var entry = Entry.new()
		entry.init(get_node(paths[i]), types[i])
		entries.append(entry)

# gets entry given path
func get_entry(path: Node) -> Entry:
	for entry in entries:
		if path.name == entry.path.name:
			return entry
	return null

# gets random Entry given current path
func get_next_path(current_path: Node) -> Entry:
	var current_entry = get_entry(current_path)
	
	# error if current path is not part of intersection
	if current_entry == null:
		push_error("Intersection.get_next_path: intersection does not contain current_path")
		return Entry.new()
	
	# remove current path from options and select random path
	var avail_entries: Array[Entry] = entries.duplicate()
	avail_entries.erase(current_entry)
	var rand_int = rng.randi_range(0, len(avail_entries)-1)
	return avail_entries[rand_int]

# sets current intersection on blob
func _on_area_entered(area):
	var blob: Blob = area.get_parent() as Blob
	
	# return if the area is not a blob
	if blob == null:
		return
	
	blob.set_intersection(self)
