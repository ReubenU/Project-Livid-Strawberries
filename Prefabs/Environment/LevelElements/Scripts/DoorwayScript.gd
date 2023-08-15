extends StaticBody

onready var is_level_completed = false


func _on_Area_body_entered(body):
	is_level_completed = true
