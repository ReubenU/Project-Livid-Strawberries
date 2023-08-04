extends Spatial

onready var head_target = $"../PlayerController/HeadTarget"

var update = false
var gt_prev:Transform
var gt_current:Transform

# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_toplevel(true)
	
	global_transform = head_target.global_transform
	
	gt_prev = head_target.global_transform
	gt_current = head_target.global_transform


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if update:
		update_transform()
		update = false
	
	var f = clamp(Engine.get_physics_interpolation_fraction(), 0, 1)
	global_transform = gt_prev.interpolate_with(gt_current, f)

func _physics_process(_delta):
	update = true

func update_transform():
	gt_prev = gt_current
	gt_current = head_target.global_transform
