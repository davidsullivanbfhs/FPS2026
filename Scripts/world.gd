extends Node3D


# Project Settings...
# General tab/DisplayWindow section, the Viewport Width = 1920, Viewport Height = 1080. 
# StretchMode = "viewport"
var player_score = 0

@onready var label := %ScoreLabel


func increase_score():
	player_score += 1
	label.text = "Score: " + str(player_score)


func do_poof(mob_position):
	const SMOKE_PUFF = preload("res://Assets/Poof/smoke_puff.tscn")
	var poof := SMOKE_PUFF.instantiate()
	add_child(poof)
	poof.global_position = mob_position
	print("ppof")


# when the mob is born we need to connect the signal to the game level
func _on_mob_spawner_3d_mob_spawned(mob):
	# connect the mob died signal to the incease score function in the game script
	#mob.died.connect(increase_score)
	# lambda function allows you to connect a function to a signal on the fly
	# we can move the increase score here and call the poof when the mob dies
	mob.died.connect(func on_mob_died():
		increase_score()
		do_poof(mob.global_position)
	)
	# do the poof when the mob is spawned
	do_poof(mob.global_position)


func _on_kill_plane_body_entered(body: Node3D) -> void:
	get_tree().reload_current_scene.call_deferred()
