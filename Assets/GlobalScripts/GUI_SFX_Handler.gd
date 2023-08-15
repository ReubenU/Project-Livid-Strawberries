extends Node

onready var gui_click = $GUIClick
onready var gui_cancel = $GUICancel
onready var gui_hover = $GUISelect
onready var menumusic = $MenuMusic

onready var ingame_hud = $"../GUI System/In-game HUD"

func _ready():
	menumusic.volume_db = linear2db(GameSettings.audio_volume/100.0)

func _process(_delta):
	if (ingame_hud.visible):
		menumusic.stop()
	else:
		if (!menumusic.playing):
			menumusic.play()

func play_gui_sfx(sfx):
	sfx.play()



func _on_Play_Game_Button_pressed():
	play_gui_sfx(gui_click)

func _on_Play_Game_Button_mouse_entered():
	play_gui_sfx(gui_hover)

func _on_Settings_Button_pressed():
	play_gui_sfx(gui_click)

func _on_Settings_Button_mouse_entered():
	play_gui_sfx(gui_hover)

# Settings buttons
func _on_Gameplay_Options_Button_pressed():
	play_gui_sfx(gui_click)

func _on_Gameplay_Options_Button_mouse_entered():
	play_gui_sfx(gui_hover)

func _on_Audio_Options_Button_pressed():
	play_gui_sfx(gui_click)

func _on_Audio_Options_Button_mouse_entered():
	play_gui_sfx(gui_hover)

func _on_BackButton_pressed():
	play_gui_sfx(gui_cancel)

func _on_BackButton_mouse_entered():
	play_gui_sfx(gui_hover)

# Pause Menu
func _on_Resume_pressed():
	play_gui_sfx(gui_click)

func _on_Resume_mouse_entered():
	play_gui_sfx(gui_hover)

func _on_Quit_pressed():
	play_gui_sfx(gui_cancel)

func _on_Quit_mouse_entered():
	play_gui_sfx(gui_hover)


func _on_Return_pressed():
	play_gui_sfx(gui_click)


func _on_Return_mouse_entered():
	play_gui_sfx(gui_hover)
