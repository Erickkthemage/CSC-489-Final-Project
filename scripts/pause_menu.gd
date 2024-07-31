extends Control

@onready var pause = $Pause
@onready var settings = $Settings


var _is_paused : bool = false:
	set(value):
		_is_paused = value
		get_tree().paused = _is_paused
		visible = _is_paused
	
func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		_is_paused = !_is_paused

func _on_resume_pressed():
	_is_paused = false

func _on_settings_pressed():
	pause.visible = false
	settings.visible = true
	
func _on_quit_pressed():
	get_tree().quit()

func _on_back_pressed():
	settings.visible = false
	pause.visible = true
	
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
func _on_mute_toggled(_toggled_on):
	if AudioServer.is_bus_mute(0):
		AudioServer.set_bus_mute(0, false)
	else:
		AudioServer.set_bus_mute(0, true)

#Handles music mute toggle
func _on_mute_2_toggled(_toggled_on):
	if AudioServer.is_bus_mute(1):
		AudioServer.set_bus_mute(1, false)
	else:
		AudioServer.set_bus_mute(1, true)

#Handles SFX mute toggle
func _on_mute_3_toggled(_toggled_on):
	if AudioServer.is_bus_mute(2):
		AudioServer.set_bus_mute(2, false)
	else:
		AudioServer.set_bus_mute(2, true)
