extends Area2D

@onready var player = $".."
@onready var killzone = $"."
var last_position = Vector2(0, 0)
var killzone_position = Vector2(0,100)
var killzone_start_position = 0

func  _ready():
	killzone_start_position = player.position.y +100
	killzone_position.y = killzone_start_position
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	move_killzone()
	
func move_killzone():
	var new_killzone_position = player.position.y + 100
	if new_killzone_position > killzone_position.y:
		killzone.position.y = new_killzone_position

func _on_body_entered(body):
	if body == player:
		print("You lost!")
