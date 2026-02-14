extends Node3D

# 
# allow each spawner to spawn different mobs
# a mob scene (from filesystem) will have to be put in to this field when placed in the level
@export var mob_to_spawn: PackedScene = null

@onready var mob_timer: Timer = %MobTimer
@onready var mob_spawn_location: Marker3D = %MobSpawnLocation

# when the mob is spawned we send a signal connecting the mob died signal to the game
signal mob_spawned(mob)

# the timer should be set to autostart
func _on_mob_timer_timeout() -> void:
	# spawn a mob
	var new_mob = mob_to_spawn.instantiate()
	add_child(new_mob)
	new_mob.global_position = mob_spawn_location.global_position
	#print("spawn a mob")
	# emit a signal connecting the mob to the game
	mob_spawned.emit(new_mob)
