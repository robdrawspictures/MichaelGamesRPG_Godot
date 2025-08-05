class_name Enemy extends CharacterBody2D

signal direction_changed(direction: Vector2)
signal enemy_damaged(hurt_box)
signal enemy_destroyed(hurt_box)

const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]

@export var hp: int = 4

var cardinal_direction: Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var player: Player
var invulnerable: bool = false

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var hit_box: HitBox = $HitBox
@onready var state_machine: EnemyStateMachine = $EnemyStateMachine

func _ready() -> void:
	state_machine.initialize(self)
	hit_box.Damaged.connect(_take_damage)
	player = PlayerManager.player
	pass
	
func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	move_and_slide()
	
func SetDirection(_new_direction: Vector2) -> bool:
	direction = _new_direction
	# If new direction input is being received do nothing
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
	direction_changed.emit(new_dir)
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
	hp -= hurt_box.damage
	if hp > 0:
		enemy_damaged.emit(hurt_box)
	else:
		enemy_destroyed.emit(hurt_box)
