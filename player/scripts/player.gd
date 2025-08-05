class_name Player extends CharacterBody2D

signal DirectionChanged(new_direction: Vector2)
signal player_damaged(hurt_box: HurtBox)

const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]

var cardinal_direction: Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO

var invulnerable: bool = false
var hp: int = 6
var max_hp: int = 6

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var effect_animation: AnimationPlayer = $EffectAnimation
@onready var hit_box: HitBox = $HitBox
@onready var sprite: Sprite2D = $Sprite2D
@onready var state_machine: PlayerStateMachine = $StateMachine

func _ready():
	PlayerManager.player = self
	state_machine.Initialize(self)
	hit_box.Damaged.connect(_take_damage)
	update_hp(99)
	pass
	
func _process(_delta: float) -> void:
	direction = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	).normalized()
	pass

	
func _physics_process(_delta: float) -> void:
	move_and_slide()

func SetDirection() -> bool:
	# If no direction input is being received do nothing
	if direction == Vector2.ZERO:
		return false
	
	# Take an angle anywhere from 0 to 360 based on current direction input
	# and do some crazy math shit that will return a number between 0 to 3
	# (The + cardinal_direction * 0.1 part is a minor fix to force animation consistency)
	var direction_id: int = int(round((direction + cardinal_direction * 0.1).angle() / TAU * DIR_4.size()))
	# Use the direction_id created above to assign a value to new_dir from one of the 4 available options in the array
	var new_dir = DIR_4[direction_id]
		
	# If the current direction input matches the existing direction input do nothing
	if new_dir == cardinal_direction:
		return false
	
	cardinal_direction = new_dir
	DirectionChanged.emit(new_dir)
	# Flip the sprite on the horizontal axis if player is facing left or right
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1	
	return true
	
func UpdateAnimation(state: String) -> void:
	anim.play(state + "_" + AnimDirection())
	pass
	
func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"
		
func _take_damage(hurt_box: HurtBox) -> void:
	if invulnerable:
		return
	update_hp(-hurt_box.damage)
	if hp > 0:
		player_damaged.emit(hurt_box)
	else:
		player_damaged.emit(hurt_box)
		update_hp(99)
	pass
	
func update_hp(delta: int) -> void:
	# clampi(value, min, max) method is used to ensure player HP
	# can't overflow past whatever the max_hp variable is set to.
	hp = clampi(hp + delta, 0, max_hp)
	PlayerHud.update_hp(hp, max_hp)
	pass
	
func make_invulnerable(_duration: float = 1.0) -> void:
	invulnerable = true
	hit_box.monitoring = false
	
	await get_tree().create_timer(_duration).timeout
	invulnerable = false
	hit_box.monitoring = true
	pass
