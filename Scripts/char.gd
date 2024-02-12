class_name Player extends CharacterBody2D


const SPEED: float = 300.0
const DASH_SPEED: float = 1000.0
const JUMP_VELOCITY: float = -400.0

@export var jumps: int
@onready var dash_gap_timer: Timer = $DashSlot
@onready var dash_cd_timer: Timer = $DashCooldown

@onready var raycast: RayCast2D = $Wallcast
var jumps_left: int
var was_on_floor: bool = true

enum { RIGHT = 1, LEFT = -1 }
var facing: int = RIGHT
var was_facing: int = RIGHT
var wall_reset: bool = true

var holding_wall: bool = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	jumps_left = jumps

func _physics_process(delta) -> void:
	# Add the gravity.
	if not is_on_floor() and not holding_wall:
		velocity.y += gravity * delta
	
	# Start timer for faster dash when landing again.
	if is_on_floor() and not was_on_floor:
		dash_gap_timer.start()
		was_on_floor = true
	
	# Reset jumps if you are on the floor, or when you touch a wall. (Only once after leaving the ground)
	if is_on_floor():
		wall_reset = true
		jumps_left = jumps
	if holding_wall and wall_reset:
		jumps_left = jumps
	
	
	# 
	if Input.is_action_just_pressed("jump") and jumps_left > 0:
		velocity.y = JUMP_VELOCITY
		jumps_left -= 1
		holding_wall = false
	
	# Drop off the wall when pressing space without being able to jump
	if Input.is_action_just_pressed("jump") and jumps_left <= 0:
		holding_wall = false
	
	# Detect if player is next to a wall it can jump off or latch onto.
	if is_on_wall_only():
		if wall_reset:
			jumps_left = jumps
			wall_reset = false
		if Input.is_action_pressed("hold_wall"):
			velocity.y = 0
			holding_wall = true
	
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("left", "right")
	if direction == 1 or direction == -1:
		facing = direction
	if direction:
		if holding_wall:
			holding_wall = false
		velocity.x = direction * SPEED
		# This wont immediately stop movement, but slow down until it stops:
		# lerp(velocity.x, direction * SPEED, 0.25)
		
		# Dash
		if Input.is_action_just_pressed("dash") and is_on_floor() and dash_cd_timer.time_left <= 0:
			if dash_gap_timer.time_left > 0:
				velocity.x += 2500 * direction
			else:
				velocity.x += 1000 * direction
			dash_cd_timer.start()
	else:
		velocity.x = lerp(velocity.x, 0.0, 0.05)
	
	if (facing == LEFT and was_facing == RIGHT) or (facing == RIGHT and was_facing == LEFT):
		raycast.rotate(deg_to_rad(180))
	
	
	was_facing = facing
	was_on_floor = is_on_floor()
	move_and_slide()
