extends Control

onready var main_menu = $"../MainMenu"
onready var buttonmenu = $"Button Menu"
onready var gameplay_menu = $"Gameplay Options"
onready var audio_menu = $"Audio Options"

onready var previous_menu = main_menu

func _on_GamePlayOptions_BackButton_pressed():
	gameplay_menu.visible = false
	buttonmenu.visible = true


func _on_Gameplay_Options_Button_pressed():
	gameplay_menu.visible = true
	buttonmenu.visible = false


func _on_BackButton_pressed():
	previous_menu.visible = true
	self.visible = false


func _on_AudioOptions_BackButton_pressed():
	audio_menu.visible = false
	buttonmenu.visible = true


func _on_Audio_Options_Button_pressed():
	audio_menu.visible = true
	buttonmenu.visible = false
