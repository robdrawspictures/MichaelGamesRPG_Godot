extends CanvasLayer

@onready var anim: AnimationPlayer = $Control/AnimationPlayer

func fade_out() -> bool:
	anim.play("fade_out")
	await anim.animation_finished
	return true
	
func fade_in() -> bool:
	anim.play("fade_in")
	await anim.animation_finished
	return true
