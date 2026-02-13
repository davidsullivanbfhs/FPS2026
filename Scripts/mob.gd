extends RigidBody3D

# a signal to tell the main scene when a mob has died
signal died
# 
var speed = randf_range(2.0, 4.0)
@onready var bat_model: Node3D = $bat_model_inherited
@export var health:= 5.0
# a reference to the player node while the game is playing
@onready var player = get_node("/root/World/Player")
@onready var delete_mob_timer: Timer = %DeleteMobTimer
@onready var ko_sound: AudioStreamPlayer3D = %KOSound
@onready var hit_sound: AudioStreamPlayer3D = %HitSound


func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	# we wont worry about moving up and down
	direction.y = 0.0
	# since the mob is a physics  body, we add physics forces to move the mob
	linear_velocity = direction * speed
	# rotate to face the player
	bat_model.rotation.y = Vector3.FORWARD.signed_angle_to(direction, Vector3.UP) + PI


func take_damage(damage):
	### need to prevent the mob from continuing to take damage after they are dead
	### we can check if health is below 0, if it is, skip the rest of the function
	if health <= 0:
		return
	# otherwise do stuff
	health -= damage
	bat_model.hurt()
	hit_sound.play()
	if health <= 0:
		ko_sound.play()
		set_physics_process(false)
		gravity_scale = 1.0
		var direction = -global_position.direction_to(player.global_position)
		var random_upward_force = Vector3.UP * randf() * 5
		apply_central_impulse(direction.rotated(Vector3.UP, randf_range(-0.2, 0.2)) * 10.0 * random_upward_force)
		# start the timer
		delete_mob_timer.start()
		# if you dont want the bat to rotate like a top if touched by the player
		# lock the mobs rotation, and then turn it back on when shot
		lock_rotation = false
		# the mob sends a signal when it dies
		died.emit()


func _on_delete_mob_timer_timeout() -> void:
	queue_free()
