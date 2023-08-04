extends Spatial

onready var weapon_prefab = preload("res://Prefabs/Weapons/Pistol.tscn")
var current_weapon

# Called when the node enters the scene tree for the first time.
func _ready():
	current_weapon = weapon_prefab.instance()
	add_child(current_weapon)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
