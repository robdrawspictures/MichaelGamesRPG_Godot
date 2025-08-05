class_name EnemyStateStun extends EnemyState

@export var anim_name: String = "stun"
@export var knockback_speed: float = 200.0
@export var decelerate_speed: float = 10.0

@export_category("AI")
@export var next_state: EnemyState

var _damage_position: Vector2
var _direction: Vector2
var _animation_finshed: bool = false

# What happens when the state is initialized
func init() -> void:
	enemy.enemy_damaged.connect(_on_enemy_damaged)
	pass # Replace with function body.

# handle Player entering this state
func enter() -> void:
	enemy.invulnerable = true
	_animation_finshed = false
	
	# Using global position to get coordinates of specific instance at that time.
	# Otherwise with enemy.position we'd get the location of the parent node,
	# which I assume is the spawn point for the enemy on load.
	
	# _damage_position was originally the player's global position for the same
	# reasons as described above, but this has been refactored as a means of
	# future-proofing for things like projectiles, bombs etc. Basically, instead
	# of being relative to where the player is, knockback is calculated relative
	# to whatever inflicted damage.
	_direction = enemy.global_position.direction_to(_damage_position)
	
	enemy.SetDirection(_direction)
	enemy.velocity = _direction * -knockback_speed
	
	enemy.UpdateAnimation(anim_name)
	enemy.anim.animation_finished.connect(_on_animation_finished)
	pass
	
# handle Player exiting this state
func exit() -> void:
	enemy.invulnerable = false
	enemy.anim.animation_finished.disconnect(_on_animation_finished)
	pass
	
func process( _delta: float) -> EnemyState:
	if _animation_finshed:
		return next_state
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	return null
	
func physics( _delta: float) -> EnemyState:
	return null
	
func _on_enemy_damaged(hurt_box: HurtBox) -> void:
	_damage_position = hurt_box.global_position
	state_machine.change_state(self)
	
func _on_animation_finished(_a: String) -> void:
	_animation_finshed = true 
