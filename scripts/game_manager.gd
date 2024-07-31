extends Node

@export var spawn_count = 100000000
@export var min_distance = 50

@onready var base_platform = preload("res://scenes/base_platform.tscn")
@onready var big_base_platform = preload("res://scenes/big_base_platform.tscn")
@onready var full_base_platform = preload("res://scenes/full_base_platform.tscn")
@onready var second_platform = preload("res://scenes/second_platform.tscn")
@onready var big_second_platform = preload("res://scenes/big_second_platform.tscn")
@onready var full_second_platform = preload("res://scenes/full_second_platform.tscn")
@onready var third_platform = preload("res://scenes/third_platform.tscn")
@onready var big_third_platform = preload("res://scenes/big_third_platform.tscn")
@onready var full_third_platform = preload("res://scenes/full_third_platform.tscn")
@onready var player = $"../Player"
@onready var score_label = $CanvasLayer/Score
@onready var high_score_label = $CanvasLayer/HighScore
@onready var pause_menu = $CanvasLayer/PauseMenu
@onready var game_over_sound = $GameOverSound
@onready var game_over_screen = $CanvasLayer/GameOverScreen

var paused = false
var rng = RandomNumberGenerator.new()
var last_platform_position = Vector2.ZERO
var next_spawn_time = 0
var platform_count = 0
var score = 0
var high_score = 0
var is_game_over = false

signal game_over
signal pause_pressed
signal resume_pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	var save_file = FileAccess.open("user://save.data", FileAccess.READ)
	if save_file != null:
		high_score = save_file.get_32()
		save_file.close()
	else:
		save_game()
		
	rng.randomize()
	high_score_label.text = "High Score: " + str(high_score)
	
func save_game():
	var save_file = FileAccess.open("user://save.data", FileAccess.WRITE)
	save_file.store_32(high_score)
	save_file.close()

func _process(_delta):
	#Spawns the platforms randomly within bounds.
	if Time.get_ticks_msec() > next_spawn_time and platform_count < spawn_count:
		var new_platform
		if (platform_count + 1) % 50 == 0 and (platform_count + 1) <= 100:
			new_platform = full_base_platform.instantiate()
		elif (platform_count + 1) % 50 == 0 and (platform_count + 1) <= 200:
			new_platform = full_second_platform.instantiate()
		elif (platform_count + 1) % 50 == 0 and (platform_count + 1) >= 250:
			new_platform = full_third_platform.instantiate()
		elif platform_count + 1 < 50:
			new_platform = big_base_platform.instantiate()
		elif platform_count + 1 < 100:
			new_platform = base_platform.instantiate()
		elif platform_count + 1 > 100 and platform_count + 1 < 150:
			new_platform = big_second_platform.instantiate()
		elif platform_count + 1 > 150 and platform_count + 1 < 200:
			new_platform = second_platform.instantiate()
		elif platform_count + 1 > 200 and platform_count + 1 < 250:
			new_platform = big_third_platform.instantiate()
		else:
			new_platform = third_platform.instantiate()
			
		if last_platform_position == Vector2.ZERO:
			new_platform.position = Vector2(400,312)
		else:
			var x
			var y
			if platform_count + 1 < 50:
				x = rng.randi_range(10, 454)
				y = clamp(last_platform_position.y - min_distance, -100000000, 312)
			elif (platform_count + 1) % 50 == 0:
				x = 232
				y = last_platform_position.y - min_distance
			else:
				x = rng.randi_range(10, 454)
				y = clamp(last_platform_position.y - min_distance, -100000000, 312)
				
			new_platform.position = Vector2(x, y)		
			
		add_child(new_platform)
		
		last_platform_position = new_platform.position
		next_spawn_time += 300
		platform_count += 1
		
	#This updates the score appropriately, as well as determining if the game should end.
	if player.is_on_floor():
		var current_height = int(abs(player.position.y -346))
		var current_floor = (current_height - 2) / 50
		if score < current_floor:
			score = current_floor
			score_label.text = "Score: " + str(score)
		elif score - current_floor >= 10 and !is_game_over:
			emit_signal("game_over")
			
	#This checks if the player pressed the pause button
	if Input.is_action_just_pressed("pause"):
		emit_signal("pause_pressed")

#Handles Game Over
func _on_game_over():
	is_game_over = true
	game_over_sound.play()
	if score > high_score:
		high_score = score
	game_over_screen.set_score(score)
	game_over_screen.set_high_score(high_score)
	save_game()
	await get_tree().create_timer(1).timeout
	game_over_screen.visible = true
	get_tree().paused = true
	
#Handles pause input
func _on_pause_pressed():
	if paused:
		pause_menu.hide()
		emit_signal("resume_pressed")

	else:
		pause_menu.show()
		get_tree().paused = true
		
	paused = !paused

#Handles resume button
func _on_resume_pressed():
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = false

#Handles player falling out of bounds
func _on_kill_zone_body_entered(_body):
	emit_signal("game_over")
	
