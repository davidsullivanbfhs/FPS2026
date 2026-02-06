extends Node3D

@onready var animation_tree: AnimationTree = %AnimationTree

func hurt():
	# make sure the oneshot node mix mode is set to add
	animation_tree.set("parameters/OneShot/request", 
	AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
