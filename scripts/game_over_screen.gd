extends Control

@onready var score = $Panel/Score
@onready var high_score = $Panel/HighScore

func _on_restart_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_pressed():
	get_tree().quit()

func set_score(value):
	score.text = "Score: " + str(value)

func set_high_score(value):
	high_score.text = "High Score: " + str(value)
