extends Spatial

onready var player = $"../../PlayerRoot"
onready var respawn_point = $"."

func _on_KillzoneE_body_entered(body):
	player.get_child(0).global_transform.origin = respawn_point.global_transform.origin
	player.get_child(0).h_velocity = Vector3.ZERO
