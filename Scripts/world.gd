extends Node3D


# Project Settings...
# General tab/DisplayWindow section, the Viewport Width = 1920, Viewport Height = 1080. 
# StretchMode = "viewport"
var player_score = 0

@onready var label := %ScoreLabel


func increase_score():
	player_score += 1
	label.text = "Score: " + str(player_score)


# when the mob is born we need to connect the signal to the game level
func _on_mob_spawner_3d_mob_spawned(mob):
	mob.died.connect(increase_score)


func _on_kill_plane_body_entered(body: Node3D) -> void:
	get_tree().reload_current_scene.call_deferred()
