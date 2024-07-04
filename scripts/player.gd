extends CharacterBody2D

@export var max_speed = 250.0
@export var acceleration = 20.0
@export var jump_velocity = -350.0
@export var bounce_jump_velocity = -600
@export var friction = 15.0

@onready var animator = $AnimatedSprite2D

var jump_grace_time = 0
var jump_count = 0
var was_on_floor = false
var is_on_floor_now
var just_landed = false
var bounce_grace_time = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	#Variable to hold the boolean value that determines if the character is on the floor.
	is_on_floor_now = is_on_floor()
	
	#Determines if the character just landed and if they fall off a platform it adds a grace time to jump again.
	if was_on_floor && !is_on_floor_now:
		just_landed = true
		if jump_count == 0:
			jump_grace_time = 0.15
		
	#Variable to hold a boolean value that says if the player was previously on the floor last frame.
	was_on_floor = is_on_floor_now
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		jump_grace_time -= delta
	else:
		jump_grace_time = 0
		bounce_grace_time -= delta
		if jump_count == 1:
			jump_count -= 1
		
	#Handles movement inputs.
	if Input.is_action_pressed("left"):
		velocity.x = move_toward(velocity.x, -max_speed, acceleration)
		animator.flip_h = true
		if is_on_floor():
			animator.play("run")
		
	if Input.is_action_pressed("right"):
		velocity.x = move_toward(velocity.x, max_speed, acceleration)
		animator.flip_h = false
		if is_on_floor():
			animator.play("run")
		
	#Handles jump input. As well as determines if character is eligible for bounce jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() || jump_grace_time > 0:
			if jump_count == 0:
				jump_count += 1
			if is_on_floor() && just_landed && bounce_grace_time > 0:
				if abs(velocity.x) > 10 :
					velocity.y = bounce_jump_velocity
					just_landed = false
					animator.play("bounce")
				else:
					bounce_grace_time = .3
					velocity.y = jump_velocity
					animator.play("jump")
			else:
				bounce_grace_time = .3
				velocity.y = jump_velocity
				animator.play("jump")
		
	#Applies friction to slow the character down if the character is on the floor and not pressing any input.
	if not Input.is_anything_pressed() && is_on_floor():
		velocity.x = move_toward(velocity.x, 0, friction)
		
	#switches animation to idle if the character is not moving.
	if velocity == Vector2.ZERO:
		animator.play("idle")
		
	move_and_slide()
