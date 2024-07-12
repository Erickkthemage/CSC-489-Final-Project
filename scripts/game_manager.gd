extends Node

@export var spawn_count = 100000000
@export var min_distance = 50

@onready var platform = preload("res://scenes/platform.tscn")
@onready var player = $"../Player"
@onready var label = $CanvasLayer/Label
@onready var pause_menu = $CanvasLayer/PauseMenu

var paused = false
var rng = RandomNumberGenerator.new()
var last_platform_position = Vector2.ZERO
var next_spawn_time = 0
var platform_count = 0
var score = 0

signal game_over
signal pause_pressed
signal resume_pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()

func _process(_delta):
	#Spawns the platforms randomly within bounds.
	if Time.get_ticks_msec() > next_spawn_time:
		var new_platform = platform.instantiate()
		
		if last_platform_position == Vector2.ZERO:
			new_platform.position = Vector2(400,312)
		elif platform_count < spawn_count:
			var x = rng.randi_range(-16, 480)
			var y = clamp(last_platform_position.y - min_distance, -100000000, 312)
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
			label.text = "Score: " + str(score)
		elif score - current_floor >= 10:
			emit_signal("game_over")
			
	#This checks if the player pressed the pause button
	if Input.is_action_just_pressed("pause"):
		emit_signal("pause_pressed")

#Handles Game Over
func _on_game_over():
	print("You lose!")
	
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
