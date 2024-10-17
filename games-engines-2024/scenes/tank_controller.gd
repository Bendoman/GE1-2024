extends MeshInstance3D

@export var speed = 20
@export var turningRotation = 60
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var movementAxis = Input.get_axis("move_forward", "move_back")
	translate(Vector3(0, 0, movementAxis * delta * speed))
	
	var rotationAxis = Input.get_axis("turn_right", "turn_left")
	rotate_y(deg_to_rad(turningRotation) * delta * rotationAxis)
