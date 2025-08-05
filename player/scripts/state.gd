class_name State extends Node

# Stores reference to the player that this state belongs to
static var player: Player
static var state_machine: PlayerStateMachine

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func init() -> void:
	pass

# handle Player entering this state
func Enter() -> void:
	pass
	
# handle Player exiting this state
func Exit() -> void:
	pass
	
func Process( _delta: float) -> State:
	return null
	
func Physics( _delta: float) -> State:
	return null
	
func HandleInput( _delta: InputEvent) -> State:
	return null
