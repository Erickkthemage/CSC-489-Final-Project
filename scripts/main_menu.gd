extends Control

@onready var play = $MarginContainer/VBoxContainer/Play

func _ready():
	play.grab_focus()

#Handles when play button is pressed on main menu
func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")

#Handles when settings button is pressed on main menu
func _on_settings_pressed():
	get_tree().change_scene_to_file("res://scenes/settings_menu.tscn")

#Handles when quit button is pressed on main menu
func _on_quit_pressed():
	get_tree().quit()
