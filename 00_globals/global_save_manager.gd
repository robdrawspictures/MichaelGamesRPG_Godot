extends Node

# NOTE: If you don't put a / after the folder it treats it as part of
# the file name, because SAVE_PATH is just a string you concatenate with
# the rest of the path.
const SAVE_PATH = "res://save_files/"

signal game_loaded
signal game_saved

#var date = Time.get_date_string_from_system()
#var save_date = date.replace("-", "_")

var current_save: Dictionary = {
	scene_path = "",
	player = {
		hp = 1,
		max_hp = 1,
		pos_x = 0,
		pos_y = 0
	},
	items = [],
	persistence = [],
	quests = [],
}

# TODO: Refactor function so it doesn't allow saving in an area that still has
# enemies present
func save_game() -> void:
	update_player_data()
	update_scene_path()
	update_item_data()
	var file := FileAccess.open(SAVE_PATH + "save.sav", FileAccess.WRITE)
	var save_json = JSON.stringify(current_save)
	file.store_line(save_json)
	game_saved.emit()
	pass

# BUG: Because you tried to be a smart arse and distinguish the save files by
# date, they can't be loaded on any other day because var_date is re-defined
# every time the script runs. IDIOT.

# Possible solution: change the load function to load whatever file has the .sav
# suffix. This will only work if there's only one save file, though.
# Alternatively, create a load menu populated by different saves.
func load_game() -> void:
	var file := FileAccess.open(SAVE_PATH + "save.sav", FileAccess.READ)
	var json := JSON.new()
	json.parse(file.get_line())
	var save_dict: Dictionary = json.get_data() as Dictionary
	current_save = save_dict
	
	LevelManager.load_new_level(current_save.scene_path, "", Vector2.ZERO)
	
	await LevelManager.loading_level
	
	PlayerManager.set_player_position(Vector2(current_save.player.pos_x, current_save.player.pos_y))
	PlayerManager.set_player_hp(current_save.player.hp, current_save.player.max_hp)
	PlayerManager.INVENTORY_DATA.parse_save_data(current_save.items)
	
	await LevelManager.level_loaded
	
	game_loaded.emit()
	
	pass

func update_player_data() -> void:
	var p: Player = PlayerManager.player
	current_save.player.hp = p.hp
	current_save.player.max_hp = p.max_hp
	current_save.player.pos_x = p.global_position.x
	current_save.player.pos_y = p.global_position.y

func update_scene_path() -> void:
	var p: String = ""
	for c in get_tree().root.get_children():
		if c is Level:
			p = c.scene_file_path
	current_save.scene_path = p

func update_item_data() -> void:
	current_save.items = PlayerManager.INVENTORY_DATA.get_save_data()
