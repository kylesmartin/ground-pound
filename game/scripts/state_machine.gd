# generic state machine, initializes states and delegates engine callbacks
# (_physics_process, _unhandled_input) to the active state
class_name StateMachine
extends Node2D

# active state, initial state set in the inspector
@export var state: State

# the name of the current state
var current_state_name: String

# emitted when transitioning to a new state
signal transitioned(state_name)

func _ready() -> void:
	# wait for the owner to be ready before running
	await owner.ready
	# the state machine assigns itself to the state objects' state_machine property
	for child in get_children():
		child.state_machine = self
	state.enter()
	state.is_active = true

# the state machine subscribes to node callbacks and delegates them to the state objects
func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)

func _process(delta: float) -> void:
	state.update(delta)

func _physics_process(delta: float) -> void:
	state.physics_update(delta)

# this function calls the current state's exit() function, changes the active state, and calls the new enter() function.
# it optionally takes a `msg` dictionary to pass to the next state's enter() function
func transition_to(target_state_name: String, msg: Dictionary = {}) -> void:
	# safety check, you could use an assert() here to report an error if the state name is incorrect
	# we don't use an assert here to help with code reuse 
	# if you reuse a state in different state machines but you don't want them all, they won't be able to transition to states that aren't in the scene tree
	if not has_node(target_state_name):
		return

	state.exit()
	state.is_active = false
	state = get_node(target_state_name)
	state.enter(msg)
	current_state_name = target_state_name
	state.is_active = true
	emit_signal("transitioned", state.name)
