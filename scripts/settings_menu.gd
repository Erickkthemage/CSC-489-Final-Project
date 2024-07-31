extends Control

@onready var back = $MarginContainer/VBoxContainer/Back

func _ready():
	back.grab_focus()

#Handles when back button is pressed on settings menu
func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

#Handles changing master volume with slider
func _on_master_value_changed(value):
	AudioServer.set_bus_volume_db(0, linear_to_db(value))

#Handles changing music volume with slider
func _on_music_value_changed(value):
	AudioServer.set_bus_volume_db(1, linear_to_db(value))

#Handles changing SFX volume with slider
func _on_sfx_value_changed(value):
	AudioServer.set_bus_volume_db(2, linear_to_db(value))

#Handles master mute toggle
func _on_mute_toggled(toggled_on):
	if AudioServer.is_bus_mute(0):
		AudioServer.set_bus_mute(0, false)
	else:
		AudioServer.set_bus_mute(0, true)

#Handles music mute toggle
func _on_mute_2_toggled(toggled_on):
	if AudioServer.is_bus_mute(1):
		AudioServer.set_bus_mute(1, false)
	else:
		AudioServer.set_bus_mute(1, true)

#Handles SFX mute toggle
func _on_mute_3_toggled(toggled_on):
	if AudioServer.is_bus_mute(2):
		AudioServer.set_bus_mute(2, false)
	else:
		AudioServer.set_bus_mute(2, true)
