extends Spatial

onready var MainGUI = $"../GUI System"
onready var hud = $"../GUI System/In-game HUD"
onready var mainmenu = $"../GUI System/MainMenu"
onready var pausemenu = $"../GUI System/PauseMenu"
onready var bg_color = $"../GUI System/BackgroundColor"
onready var winmenu = $"../GUI System/WinMenu"

const game_level_path = "res://Levels/ActualLevel.tscn"

onready var game_level

var level_deleted = false

func _ready():	
	MainGUI.connect("start_game", self, "_on_Start_Game")
	
func _process(delta):
	pause_game()
	
	if (level_deleted == true):
		if (is_instance_valid(game_level)):
			remove_child(get_child(0))
			game_level.queue_free()
	else:
		on_level_completed()

func pause_game():
	if (Input.is_action_just_pressed("ui_cancel") and get_child_count() == 1):
		get_tree().paused = !get_tree().paused
		
		if (get_tree().paused):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
		pausemenu.visible = get_tree().paused
		hud.visible = !get_tree().paused

var x = 0
func on_level_completed():
	if (game_level != null):
		if (game_level.get_child(0).is_level_completed and x == 0):
			get_tree().paused = true
			hud.visible = false
			winmenu.visible = true
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_Start_Game():
	game_level = preload(game_level_path).instance()
	add_child(game_level)
	level_deleted = false


func _on_MouseSpeedText_text_changed(new_text):
	if (new_text.is_valid_float()):
		GameSettings.mouse_sensitivity = float(new_text)


func _on_MouseSmoothText_text_changed(new_text):
	if (new_text.is_valid_float()):
		GameSettings.mouse_smoothing = float(new_text)


func _on_Music_Slider_value_changed(value):
	GameSettings.music_volume = value

func _on_SFX_Slider_value_changed(value):
	GameSettings.sfx_volume = value

func _on_Resume_pressed():
	hud.visible = true
	pausemenu.visible = false
	
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_Quit_pressed():
	mainmenu.visible = true
	hud.visible = false
	bg_color.visible = true
	pausemenu.visible = false
	
	level_deleted = true
	
	get_tree().paused = false

func _on_Return_pressed():
	mainmenu.visible = true
	bg_color.visible = true
	winmenu.visible = false
	
	level_deleted = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = false
