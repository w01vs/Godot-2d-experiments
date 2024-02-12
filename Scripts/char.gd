class_name Player extends CharacterBody2D


const SPEED: float = 300.0
const DASH_SPEED: float = 1000.0
const JUMP_VELOCITY: float = -400.0

@export var jumps: int
var jumps_left: int

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if is_on_floor():
		jumps_left = jumps
	if Input.is_action_just_pressed("ui_accept") and jumps_left > 0:
		velocity.y += JUMP_VELOCITY
		jumps_left -= 1
	
	# Dash
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = lerp(velocity.x, direction * SPEED, 0.25)
		# dash needs to lerp x position.
		if Input.is_action_just_pressed("dash") and is_on_floor():
			velocity.x += 1000 * direction
	else:
		velocity.x = lerp(velocity.x, 0.0, 0.05)
	
	move_and_slide()
