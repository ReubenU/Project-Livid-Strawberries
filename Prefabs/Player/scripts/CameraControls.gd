extends Spatial

onready var player_body = $".."

export var mouse_sens:float = 10;
export var smooth_speed = 40;

var bodyRot:float = 0;
var camRot:float = 0;
var currentCamRot = 0

var deltaTime:float = 0;

# Handle inputs here.
func _input(event):
	# Handle mouse capturing.
	lock_mouse(event);
	handle_mouse_motion_input(event)

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	deltaTime = delta
	apply_mouselook_rotation()

#### MOUSE LOOK SECTION ####

# Apply mouse-look rotation to player controller
# after the rotation values have been modified by
# handle_mouse_motion_input()
func apply_mouselook_rotation():
	# Interpolate the camera pitch to the new pitch rotation.
	currentCamRot = lerp(currentCamRot, camRot, deltaTime * smooth_speed)
	
	# Interpolate current body transform towards the modified/new
	# rotation transform.
	var currentBodyQuat:Quat = Quat(player_body.transform.basis);
	var bodyVector:Quat = Quat(Vector3.DOWN, deg2rad(bodyRot));
	var smoothBodyRot:Quat = currentBodyQuat.slerp(bodyVector, deltaTime * smooth_speed);
	
	# Apply the resultant basis to the current basis.
	player_body.transform.basis = Basis(smoothBodyRot);
	
	# Apply the smoothed camera pitch rotation to the camera rotation.
	rotation_degrees = Vector3.LEFT * currentCamRot

# Handle mouse motion input separately from the rotation.
#
# This helps smooth out jitter caused by the difference of
# ticks between the _input function and the _physics_process
# function.
func handle_mouse_motion_input(event:InputEvent):
	if (event is InputEventMouseMotion):
		camRot += event.relative.y * mouse_sens * deltaTime;
		bodyRot += event.relative.x * mouse_sens * deltaTime;
		
		camRot = clamp(camRot, -90, 90);
		
		bodyRot = repeat(bodyRot, 360);
		
		event.relative = Vector2.ZERO;

# Lock and hide the mouse cursor in the window.
func lock_mouse(event:InputEvent):
	if (event.is_action_pressed("ui_cancel")):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
		
	if (event.is_action_pressed("ui_accept")):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;

#### END MOUSE LOOK SECTION ####

# Repeat value; analogous to Unity's Mathf.Repeat()
func repeat(value:float, maxValue:float)->float:
	
	var isLower:int = int(value < 0);
	var isUpper:int = int(value > maxValue);
	var inRange:int = int(value >= 0 and value <= maxValue);
	
	return (isLower*(maxValue+value)) + (isUpper*(value-maxValue)) + (inRange*value);
