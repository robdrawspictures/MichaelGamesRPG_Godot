class_name PlayerCamera extends Camera2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Listen for changes to the current tilemap being displayed
	# And update the scene (i.e. moving from screen to screen in Zelda)
	LevelManager.TilemapBoundsChanged.connect(UpdateLimits)
	# On boot, get the default tilemap from the level manager to render
	# i.e. the start screen
	UpdateLimits(LevelManager.current_tilemap_bounds)
	pass # Replace with function body.

func UpdateLimits(bounds: Array[Vector2]) -> void:
	# Fail safe in case the game loads assets in an unexpected order
	if bounds == []:
		return
	limit_left = int(bounds[0].x)
	limit_top = int(bounds[0].y)
	limit_right = int(bounds[1].x)
	limit_bottom = int(bounds[1].y)
	pass
