class_name ItemEffectHeal extends ItemEffect

@export var heal_amount: int = 1
@export var sound: AudioStream

# TODO: This currently half works as intended, you can still
# use a potion at full health and it will disappear out the
# inventory.
func use() -> void:
	if PlayerManager.player.hp < PlayerManager.player.max_hp:
		PlayerManager.player.update_hp(heal_amount)
		PauseMenu.play_audio(sound)
		
	print("HP full, cannot use item!")
	return
		
