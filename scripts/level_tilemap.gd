class_name LevelTilemap extends TileMap



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# On load, get the coordinates of the tilemap and relay to the global level manager
	LevelManager.ChangeTilemapBounds(GetTilemapBounds())
	pass # Replace with function body.
	
func GetTilemapBounds() -> Array[Vector2]:
	var bounds: Array[Vector2]
	bounds.append(
		# Gets the top-left coordinate of the tilemap
		Vector2(get_used_rect().position * rendering_quadrant_size)
	)
	bounds.append(
		# Gets the bottom-right coordinate of the tilemap
		Vector2(get_used_rect().end * rendering_quadrant_size)
	)
	
	return bounds
