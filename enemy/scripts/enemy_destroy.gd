class_name EnemyStateDestroy extends EnemyState

const PICKUP = preload("res://items/item_pickup/item_pickup.tscn")

@export var anim_name: String = "destroy"
@export var knockback_speed: float = 200.0
@export var decelerate_speed: float = 10.0

@export_category("AI")

@export_category("Item Drops")
@export var drops: Array[DropData]

var _damage_position: Vector2
var _direction: Vector2

# What happens when the state is initialized
func init() -> void:
	enemy.enemy_destroyed.connect(_on_enemy_destroyed)
	pass # Replace with function body.

# handle Player entering this state
func enter() -> void:
	enemy.invulnerable = true
	
	# Using global position to get coordinates of specific instance at that time.
	# Otherwise with enemy.position we'd get the location of the parent node,
	# which I assume is the spawn point for the enemy on load.
	_direction = enemy.global_position.direction_to(_damage_position)
	
	enemy.SetDirection(_direction)
	enemy.velocity = _direction * -knockback_speed
	
	enemy.UpdateAnimation(anim_name)
	enemy.anim.animation_finished.connect(_on_animation_finished)
	disable_hurt_box()
	drop_items()
	pass
	
# handle Player exiting this state
func exit() -> void:
	pass
	
func process( _delta: float) -> EnemyState:
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	return null
	
func physics( _delta: float) -> EnemyState:
	return null
	
func _on_enemy_destroyed(hurt_box: HurtBox) -> void:
	_damage_position = hurt_box.global_position
	state_machine.change_state(self)
	
func _on_animation_finished(_a: String) -> void:
	enemy.queue_free()
	
func disable_hurt_box() -> void:
	var hurt_box: HurtBox = enemy.get_node_or_null("HurtBox")
	if hurt_box:
		hurt_box.monitoring = false

func drop_items() -> void:
	if drops.size() == 0:
		return
		
	for i in drops.size():
		if drops[i] == null or drops[i].item == null:
			continue
		var drop_count: int = drops[i].get_drop_count()
		for j in drop_count:
			var drop: ItemPickup = PICKUP.instantiate() as ItemPickup
			drop.item_data = drops[i].item
			# Directly calling the add_child() method can cause bugs, so
			# using call_deferred() forces the system to wait until it's
			# safe, also holding onto the argument you want to pass in.
			
			# It's basically an await for when you don't know specifically
			# what you're waiting to be done.
			enemy.get_parent().call_deferred("add_child", drop)
			drop.global_position = enemy.global_position
			drop.velocity = enemy.velocity.rotated(randf_range(-1.5, 1.5) + randf_range(0.9, 1.5))
	pass
