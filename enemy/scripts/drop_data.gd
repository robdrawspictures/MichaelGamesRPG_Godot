class_name DropData extends Resource

@export var item: ItemData
@export_range(0, 100, 1, "suffix:%") var probability: float = 100 # i.e. drop rate
@export_range(1, 10, 1, "suffix:items") var min_amount: int = 1
@export_range(1, 10, 1, "suffix:items") var max_amount: int = 1

# NOTE: The above figures are defaults, the actual drop rate and min/max are defined
# on the Destroy state of the Enemy scene (slime.tscn), and can be configured on
# a per item basis. Very cool!
func get_drop_count() -> int:
	# If random number is equal or above probability, you get nothing.
	# Example: If you set probability to 90 and get 91, then too
	# fucking bad.
	if randf_range(0,100) >= probability:
		return 0
		
	# If you get lucky, roll the dice again on how many of that item
	# will drop.
	return randi_range(min_amount, max_amount)
