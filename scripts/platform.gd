extends AnimatableBody2D

@export var spawn_count = 200
var platform_scene = preload("res://scenes/platform.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in spawn_count:
		var platform = platform_scene.instantiate()
		add_child(platform)
		
		platform.position.x = randi_range(-16, 480)
		platform.position.y = randi_range(0, 312)
