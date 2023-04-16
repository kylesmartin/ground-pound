# virtual base class for all states.
class_name State
extends Node2D

# reference to the state machine, to call its `transition_to()` method directly
# the state machine node will set this reference
var state_machine = null

# is this state active?
var is_active = false

# virtual function, receives events from the `_unhandled_input()` callback
func handle_input(_event: InputEvent) -> void:
	pass

# virtual functionm corresponds to the `_process()` callback
func update(_delta: float) -> void:
	pass

# virtual function, corresponds to the `_physics_process()` callback
func physics_update(_delta: float) -> void:
	pass

# virtual function, called by the state machine upon changing the active state
# the `msg` parameter is a dictionary with arbitrary data that the state can use to initialize itself
func enter(_msg := {}) -> void:
	pass

# virtual function, called by the state machine before changing the active state
# use this function to clean up the state
func exit() -> void:
	pass
