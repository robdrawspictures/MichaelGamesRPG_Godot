class_name State_Attack extends State

var attacking: bool = false

@export var attack_sound: AudioStream
@export_range(1, 20, 0.5) var decelerate_speed: float = 0.5

@onready var walk: State = $"../Walk"
@onready var idle: State = $"../Idle"
@onready var anim: AnimationPlayer = $"../../AnimationPlayer"
@onready var attack_anim: AnimationPlayer = $"../../Sprite2D/AttackEffect/AnimationPlayer"
@onready var audio: AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"
@onready var hurt_box: HurtBox = %AttackHurtBox

# handle Player entering this state
func Enter() -> void:
	player.UpdateAnimation("attack")
	attack_anim.play("attack_" + player.AnimDirection())
	anim.animation_finished.connect(EndAttack)
	audio.stream = attack_sound
	# Very subtly alters the pitch of the SFX at random to create variety
	audio.pitch_scale = randf_range(0.9, 1.1)
	audio.play()
	
	attacking = true
	# Forces a slight delay before the hurtbox becomes active to allow attack animation to complete
	await get_tree().create_timer(0.075).timeout
	if attacking:
		hurt_box.monitoring = true
	pass
	
# handle Player exiting this state
func Exit() -> void:
	anim.animation_finished.disconnect(EndAttack)
	attacking = false
	hurt_box.monitoring = false
	pass
	
func Process( _delta: float) -> State:
	player.velocity = player.velocity * decelerate_speed * _delta
	
	if attacking == false:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
	return null
	
func Physics( _delta: float) -> State:
	return null
	
func HandleInput( _delta: InputEvent) -> State:
	return null

func EndAttack(_newAnimName: String ):
	attacking = false
