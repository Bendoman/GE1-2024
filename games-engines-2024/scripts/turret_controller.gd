extends MeshInstance3D

@export var turretRotation = 60

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	Rotates turret based on user input
	var turretRotationAxis = Input.get_axis("rotate_turret_right", "rotate_turret_left")
	rotate_y(deg_to_rad(turretRotation) * delta * turretRotationAxis)
