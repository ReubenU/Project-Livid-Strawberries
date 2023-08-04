extends KinematicBody

export var run_speed = 6
export var walk_speed = 2
export var h_acceleration = 6
export var air_acceleration = 1
export var normal_acceleration = 6
var input_dir = Vector2()
var h_velocity = Vector3()
var lin_velocity = Vector3.ZERO
var movement_speed = run_speed

export var crouch_acceleration = 5
export var camera_stand_height = 0.5
export var camera_crouch_height = 0.0
var camera_height = camera_stand_height
var crouch_percent = 0.0

# Jump variables
export var jump_height:float = 2
export var gravity = 9.82
export var coyote_time = 0.2
var gravity_vector = Vector3.DOWN
var full_contact = false

onready var ground_check = $GroundCheck
onready var stand_collider = $StandingCollider
onready var crouch_collider = $CrouchingCollider
onready var overhead_detector = $OverheadDetector
onready var wall_detector = $WallDetector
onready var step_detector = $WallDetector/StepDetector
onready var coyote_timer = $CoyoteTimer
onready var head_target = $HeadTarget

var input_event:InputEvent;

# Handle inputs here.
func _unhandled_input(event):
	input_event = event;
	
	# Make a normalized input Vector2
	input_dir = movement_axes(
		"move_forward",
		"move_backward",
		"move_left",
		"move_right"
	)

# Called when the node enters the scene tree for the first time.
func _ready():
	coyote_timer.wait_time = coyote_time


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	handle_movement(delta)
	handle_walking()
	crouch(delta)


#### Movement functions ####
func handle_movement(delta):
	
	# Check if the player is fully grounded
	if ground_check.is_colliding():
		full_contact = true
	else:
		full_contact = false

	# Fall or stick to floor
	if (is_on_floor() == false):
		gravity_vector += Vector3.DOWN * gravity * delta
		h_acceleration = air_acceleration
	elif (is_on_floor() and full_contact):
		gravity_vector = -get_floor_normal() * gravity
		h_acceleration = normal_acceleration
	else:
		gravity_vector = -get_floor_normal()
		h_acceleration = normal_acceleration
	
	# If the player jumps into the ceiling, make them
	# bounce back.
	if (is_on_ceiling() and is_on_floor() == false):
		gravity_vector = Vector3.DOWN
	
	# Handle steps and stairs
	handle_steps()
	
	# Jump
	var can_jump = is_on_floor() or (full_contact or !coyote_timer.is_stopped())
	if (Input.is_action_just_pressed("jump") and can_jump):
		var jump_velocity = sqrt(gravity * 2 * jump_height)
		gravity_vector = Vector3.UP * jump_velocity
	
	
	# Localize and project the movement direction on the floor
	# normal plane.
	var local_x = transform.basis.x * input_dir.x * movement_speed
	var local_z = transform.basis.z * input_dir.y * movement_speed
	var velocity:Vector3 = local_x + local_z

	h_velocity = h_velocity.linear_interpolate(velocity, h_acceleration * delta)
	
	var projected_velocity = Plane(get_floor_normal(), 0).project(h_velocity)
	
	var was_on_floor = is_on_floor()
	
	lin_velocity = move_and_slide(
		projected_velocity + gravity_vector,
		Vector3.UP, false, 4, deg2rad(45)
	)

	if (was_on_floor and !is_on_floor()):
		coyote_timer.start()
	
func handle_walking():
	if Input.is_action_pressed("walk"):
		movement_speed = walk_speed
	else:
		movement_speed = run_speed

func crouch(deltaTime):
	if hasCrouched(Input.is_action_pressed("crouch"), deltaTime):
		crouch_collider.disabled = false
		stand_collider.disabled = true
		
		if is_on_floor():
			movement_speed = walk_speed
		else:
			movement_speed = run_speed
	else:
		stand_collider.disabled = false
		crouch_collider.disabled = true
		# No need to reset movement_speed 
		# back to run_speed since the function
		# walk() is already doing that.

func hasCrouched(isCrouching, deltaTime):
	if (isCrouching or overhead_detector.is_colliding()):
		
		if (crouch_percent > 0.95):
			head_target.translation = Vector3.UP * camera_crouch_height
			crouch_percent = 1
			return true
		
		crouch_percent += crouch_acceleration * deltaTime
		crouch_percent = clamp(crouch_percent, 0, 1)
		camera_height = lerp(camera_stand_height, camera_crouch_height, crouch_percent)
		
		head_target.translation = Vector3.UP * camera_height
		
		if (!is_on_floor()):
			var displacement = lerp(camera_stand_height, camera_crouch_height, crouch_percent)
			var disp_velocity = sqrt(gravity * 2 * displacement)
			var _v = move_and_slide(disp_velocity * Vector3.UP, Vector3.UP, false, 4)
			
			
			
	elif (!isCrouching):
		if (crouch_percent < 0.05):
			head_target.translation=Vector3.UP * camera_stand_height
			crouch_percent = 0
			return false
		
		crouch_percent -= crouch_acceleration * deltaTime
		crouch_percent = clamp(crouch_percent, 0, 1)
		camera_height = lerp(camera_stand_height, camera_crouch_height, crouch_percent)
		
		head_target.translation = Vector3.UP * camera_height
		
		if (!is_on_floor()):
			var displacement = lerp(camera_crouch_height, camera_stand_height, crouch_percent)
			var disp_velocity = sqrt(gravity * 2 * displacement)
			var _v = move_and_slide(disp_velocity * Vector3.DOWN, Vector3.UP, false, 4)
	
	return false

# Makes the player go up
# stairs or steps.
func handle_steps():
	wall_detector.enabled = (input_dir.length() > 0 and is_on_wall())
	
	var cast_dir = Vector3(input_dir.x, 0, input_dir.y)
	wall_detector.cast_to = cast_dir * stand_collider.shape.radius * 2
	
	step_detector.translation = wall_detector.cast_to
	step_detector.enabled = (wall_detector.enabled and (wall_detector.is_colliding() == false))
	
	if (step_detector.is_colliding() and is_on_ceiling() == false):
		var hitpoint = step_detector.get_collision_point()
		var step_height = step_detector.global_translation.distance_to(hitpoint)
		
		var step_hop = sqrt(gravity * 2 * abs(-step_detector.cast_to.y-step_height))
		gravity_vector = Vector3.UP * step_hop
		

# Helper function that creates and returns a normalized Vector2 from
# a set of actions.
func movement_axes(forward_action, back_action, left_action, right_action):
	var axis:Vector2 = Vector2.ZERO
	
	if (Input.is_action_pressed(forward_action)):
		axis.y = -1
	elif (Input.is_action_pressed(back_action)):
		axis.y = 1
	else:
		axis.y = 0
	
	if (Input.is_action_pressed(left_action)):
		axis.x = -1
	elif (Input.is_action_pressed(right_action)):
		axis.x = 1
	else:
		axis.x = 0
	
	return axis.normalized()

#### Ungrounded state ####
func swim():
	pass
