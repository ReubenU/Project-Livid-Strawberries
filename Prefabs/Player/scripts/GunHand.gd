extends Spatial

onready var tether_ray = $TetherRay

signal activate_tether(hitpos)
signal place_tether_cursor(hitpos)
signal hide_tether_cursor()
signal deactivate_tether()

signal tether_fail()
signal tether_hook()
signal tether_held()

var hitPos = Vector3.ZERO

func _process(_delta):
	test_fire_tether()

func test_fire_tether():
	if (Input.is_action_pressed("fire_weapon")):
		if (tether_ray.enabled and tether_ray.is_colliding()):
			hitPos = tether_ray.get_collision_point()
			tether_ray.enabled = false
			emit_signal("tether_hook")
		
		elif (tether_ray.enabled == false):
			emit_signal("activate_tether", hitPos)
			emit_signal("tether_held")
		
		elif (tether_ray.enabled and !tether_ray.is_colliding()):
			emit_signal("tether_fail")
		
	elif (Input.is_action_just_released("fire_weapon")):
		tether_ray.enabled = true
		emit_signal("deactivate_tether")
	
	elif (tether_ray.is_colliding()):
		hitPos = tether_ray.get_collision_point()
		emit_signal("place_tether_cursor", hitPos)
	
	elif (!tether_ray.is_colliding()):
		emit_signal("hide_tether_cursor")
