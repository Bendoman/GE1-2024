extends RigidBody3D

@export var time:float = 0 
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


var printed = false
func _physics_process(delta):
	if global_position.y > 0:
		time += delta
	elif not printed:
		print('RigidBody:\nTime: ', time, '\nVelocity: ', linear_velocity)
		printed = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
