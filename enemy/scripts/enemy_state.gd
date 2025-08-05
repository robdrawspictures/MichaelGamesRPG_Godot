class_name EnemyState extends Node

var enemy: Enemy
var state_machine: EnemyStateMachine

# What happens when the state is initialized
func init() -> void:
	pass # Replace with function body.

# handle Player entering this state
func enter() -> void:
	pass
	
# handle Player exiting this state
func exit() -> void:
	pass
	
func process( _delta: float) -> EnemyState:
	return null
	
func physics( _delta: float) -> EnemyState:
	return null
