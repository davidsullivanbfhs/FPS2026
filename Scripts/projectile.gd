extends Area3D

# expose use @export var
const SPEED = 20.0
const RANGE = 40.0
@export var damage:= 1.0

var travelled_distance = 0.0

func _physics_process(delta: float) -> void:
	position += transform.basis.z * SPEED * delta
	
	travelled_distance += SPEED * delta
	
	# delete the bullet if it goes to far, you could also set up kill planes
	if travelled_distance > RANGE:
		queue_free()


func _on_body_entered(body: Node3D) -> void:
	# check if the thing the bullet hit is a damagable body
	if body.has_method("take_damage"):
		body.take_damage(damage)
	#it hit something so destroy bullet
	queue_free()
