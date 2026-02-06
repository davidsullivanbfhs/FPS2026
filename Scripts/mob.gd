extends RigidBody3D

@onready var bat_model: Node3D = $bat_model_inherited
@export var health:= 5.0

func take_damage(damage):
	health -= damage
	bat_model.hurt()
	if health <= 0:
		set_physics_process(false)
		gravity_scale = 1.0
	print(health)
