class_name HitBox extends Area2D

signal Damaged(hurt_box: HurtBox)

func _ready() -> void:
	pass
	
func _process(_delta: float) -> void:
	pass

func TakeDamage(hurt_box: HurtBox) -> void:
	#print("Hit for " + str(hurt_box.damage) + " damage!")
	Damaged.emit(hurt_box)
