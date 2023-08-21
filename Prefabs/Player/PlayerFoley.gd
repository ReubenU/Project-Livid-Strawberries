extends Spatial

onready var air_sfx = $PlayerAir
onready var tether_hook_sfx = $PlayerTetherHooked
onready var tether_unhook_sfx = $PlayerTetherUnhooked
onready var tether_fail_sfx = $PlayerTetherNoSurface

onready var footsteps = [
	$Footstep1,
	$Footstep2,
	$Footstep3,
	$Footstep4
]

onready var all_sfx = [
	air_sfx,
	tether_hook_sfx,
	tether_unhook_sfx,
	tether_fail_sfx
]

onready var tether_gun = $"../PlayerController/HeadTarget/GunHand"
onready var player = $"../PlayerController"

var is_tether_held = false

var rng = RandomNumberGenerator.new()

func _ready():
	on_Audio_Setting_Changed()
	
	tether_gun.connect("tether_fail", self, "_on_Tether_No_Surface")
	tether_gun.connect("tether_hook", self, "_on_Tether_Hooked")
	tether_gun.connect("tether_held", self, "_on_Tether_Held")
	tether_gun.connect("deactivate_tether", self, "_on_Tether_Released")
	
	rng.randomize()

func _process(_delta):
	#on_Audio_Setting_Changed()
	
	if (tether_hook_sfx.playing and !is_tether_held):
		if (tether_hook_sfx.get_playback_position() >= 0.70):
			tether_hook_sfx.stop()
	
	if (!player.is_on_floor() and player.lin_velocity.length() > 20):
		if (!air_sfx.playing):
			var air_volume = clamp(player.lin_velocity.length() / 200, 0, 1)
			air_sfx.volume_db = linear2db(air_volume)
			air_sfx.play()
	if (player.is_on_floor()):
		if (air_sfx.playing):
			air_sfx.stop()
		
		if (round(player.h_velocity.length()) > 0):
			random_footstep()

func on_Audio_Setting_Changed():
	for sfx in all_sfx:
		sfx.volume_db = linear2db(GameSettings.sfx_volume/100.0)
	
	for footstep in footsteps:
		footstep.volume_db = linear2db(GameSettings.sfx_volume/100.0)

onready var last_footstep = footsteps[0]
func random_footstep():
	var foot_index = rng.randi_range(0, len(footsteps)-1)
	
	if (!footsteps[foot_index].playing and !last_footstep.playing):
		footsteps[foot_index].play()
		last_footstep = footsteps[foot_index]

func _on_Tether_Hooked():
	if (!tether_hook_sfx.playing):
		tether_hook_sfx.play()

func _on_Tether_Held():
	if (!tether_hook_sfx.playing and is_tether_held):
		tether_hook_sfx.play(.75)
	is_tether_held = true

func _on_Tether_Released():
	is_tether_held = false
	
	if (!tether_unhook_sfx.playing):
		tether_unhook_sfx.play()

func _on_Tether_No_Surface():
	if (!tether_fail_sfx.playing):
		tether_fail_sfx.play()
