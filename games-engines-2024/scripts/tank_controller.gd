extends CharacterBody3D

@export var speed = 20
@export var turningRotation = 200
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
#	Translate tank based on user input
	var movementAxis = Input.get_axis("move_forward", "move_back")
	#translate(Vector3(0, 0, movementAxis * delta * speed))
	var v = Vector3()
	v = global_transform.basis.z
	velocity = v * speed * movementAxis
	move_and_slide()
	
	
#	Rotates tank based on user input
	var rotationAxis = Input.get_axis("turn_right", "turn_left")
	rotate_y(deg_to_rad(turningRotation) * delta * rotationAxis)
	
	DebugDraw2D.set_text("position", position)
	DebugDraw2D.set_text("global_position", global_position)
	DebugDraw2D.set_text("basis.x", transform.basis.x)
	DebugDraw2D.set_text("basis.y", transform.basis.y)
	DebugDraw2D.set_text("basis.z", transform.basis.x)
	DebugDraw2D.set_text("global basis.x", global_transform.basis.x)
	DebugDraw2D.set_text("global basis.y", global_transform.basis.y)
	DebugDraw2D.set_text("global basis.z", global_transform.basis.x)
	
