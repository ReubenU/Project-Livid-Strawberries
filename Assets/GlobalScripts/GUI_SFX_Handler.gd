extends Node

onready var gui_click = $GUIClick
onready var gui_cancel = $GUICancel
onready var gui_hover = $GUISelect
onready var menumusic = $MenuMusic
onready var gamemusic = $GameMusic
onready var samplefoley = $SamplePlayerFoley

onready var ingame_hud = $"../GUI System/In-game HUD"

func _ready():
	menumusic.volume_db = linear2db(GameSettings.music_volume/100.0)
	gamemusic.volume_db = linear2db(GameSettings.music_volume/100.0)
	
	gui_click.volume_db = linear2db(GameSettings.sfx_volume/100.0)
	gui_hover.volume_db = linear2db((GameSettings.sfx_volume*4)/100.0)
	gui_cancel.volume_db = linear2db(GameSettings.sfx_volume/100.0)

func _process(_delta):
	if (ingame_hud.visible):
		menumusic.stop()
		if (!gamemusic.playing):
			gamemusic.play()
	else:
		if (!menumusic.playing):
			menumusic.play()
			gamemusic.stop()
			

func play_gui_sfx(sfx):
	sfx.play()

func _on_Mouse_Hover():
	play_gui_sfx(gui_hover)

func _on_Mouse_Click():
	play_gui_sfx(gui_click)
	
func _on_Back_Button_Clicked():
	play_gui_sfx(gui_cancel)


func _on_Music_Slider_value_changed(value):
	menumusic.volume_db = linear2db(value/100.0)
	gamemusic.volume_db = linear2db(value/100.0)

func _on_SFX_Slider_value_changed(value):
	gui_click.volume_db = linear2db(value/100.0)
	gui_hover.volume_db = linear2db((value*2)/100.0)
	gui_cancel.volume_db = linear2db(value/100.0)
	
	samplefoley.volume_db = linear2db(value/100.0)
	
	if (!samplefoley.playing):
		samplefoley.play()
	
