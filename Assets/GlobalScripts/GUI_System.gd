extends Control

signal start_game()

onready var ingameHUD = $"In-game HUD"
onready var mainmenu = $MainMenu
onready var pausemenu = $PauseMenu
onready var bg_rect = $BackgroundColor

onready var settings = $"Settings Menu"
onready var settings_buttons_menu = $"Settings Menu/Button Menu"
onready var gameplay_options = $"Settings Menu/Gameplay Options"
onready var audio_options = $"Settings Menu/Audio Options"

func _on_Play_Game_Button_button_down():
	emit_signal("start_game")

	ingameHUD.visible = true
	mainmenu.visible = false
	bg_rect.visible = false


func _on_Settings_Button_pressed():
	settings.visible = true
	mainmenu.visible = false
	
	settings.previous_menu = mainmenu
