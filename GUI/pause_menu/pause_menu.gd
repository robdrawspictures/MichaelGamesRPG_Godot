extends CanvasLayer

signal shown
signal hidden

@onready var audio_stream_player: AudioStreamPlayer = $Control/AudioStreamPlayer
@onready var button_save: Button = $Control/VBoxContainer/Button_Save
@onready var button_load: Button = $Control/VBoxContainer/Button_Load
@onready var button_quit: Button = $Control/VBoxContainer/Button_Quit
@onready var close_menu: Button = $Control/Close_Menu
@onready var item_description: Label = $Control/ItemDescription
@onready var item_name: Label = $Control/ItemName

var is_paused: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_pause_menu()
	button_save.pressed.connect(_on_save_pressed)
	button_load.pressed.connect(_on_load_pressed)
	button_quit.pressed.connect(_on_quit_pressed)
	close_menu.pressed.connect(hide_pause_menu)
	pass # Replace with function body.

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if is_paused == false:
			show_pause_menu()
		else:
			hide_pause_menu()
		get_viewport().set_input_as_handled()
		
func show_pause_menu() -> void:
	get_tree().paused = true
	visible = true
	is_paused = true
	shown.emit()
	
func hide_pause_menu() -> void:
	get_tree().paused = false
	visible = false
	is_paused = false
	hidden.emit()

func _on_save_pressed() -> void:
	if !is_paused:
		return
	SaveManager.save_game()
	hide_pause_menu()
	pass
	
# TODO: Game currently crashes if attempting to load with no save file existing
# This is possibly because 
func _on_load_pressed() -> void:
	if !is_paused:
		return
	SaveManager.load_game()
	await LevelManager.loading_level
	hide_pause_menu()
	pass
	
func _on_quit_pressed() -> void:
	get_tree().quit()
	pass
	
func _on_close_menu() -> void:
	hide_pause_menu()

func update_item_description(new_text: String) -> void:
	item_description.text = new_text

func update_item_name(new_text: String) -> void:
	item_name.text = new_text

func play_audio(audio: AudioStream) -> void:
	audio_stream_player.stream = audio
	audio_stream_player.play()
