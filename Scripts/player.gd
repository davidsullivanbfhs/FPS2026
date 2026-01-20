extends CharacterBody3D
#MOVE THE CAMERA AROUND WITH THE MOUSE
#move the player with the keyboard
#constrain the mouse
#jump
#capture the mouse
### figure out why jumps has two 0s
@export var gravity:float = 20
@export var max_jumps:int = 2
var jumps: int = 0

#shooting


func _ready() -> void:
	#capture the mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		#rotate player
		rotation_degrees.y -= event.screen_relative.x * 0.5
		# rotate up and down camera
		%Camera3D.rotation_degrees.x -= event.screen_relative.y * 0.2
		%Camera3D.rotation_degrees.x = clamp(%Camera3D.rotation_degrees.x, -80.0, 80.0)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("fullscreen"):
		#bool true or false
		var fs = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
		if fs: 
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _physics_process(delta: float) -> void:
	const SPEED = 5.5 # meters per second
	#walk
	var input_direction_2D = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	#make 2d vector into 3d vector
	var input_direction_3D = Vector3(input_direction_2D.x, 0, input_direction_2D.y)
	
	# the basis is the players current rotation which is changed by mouse movement
	var direction = transform.basis * input_direction_3D
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED
	### jumping ###
	#gravity
	#y direction
	velocity.y -= gravity * delta
	# check for the jump key
	if Input.is_action_just_pressed("jump") and jumps < max_jumps:#is_on_floor():
		velocity.y = 10.0
		# add to jumps
		print("start = ", jumps)
		jumps += 1
		print("end = ", jumps)
		# jumps is being zeroed out after the first time it is triggered
		
	elif Input.is_action_just_released("jump") and velocity.y > 0.0:
		velocity.y = 0.0
	
	if is_on_floor():
		print("zero jumps")
		jumps = 0
	
	move_and_slide()
