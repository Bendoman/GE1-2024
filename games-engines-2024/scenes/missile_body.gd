extends MeshInstance3D

@export var speed:int = 90
var time_elapsed:float = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	translate(Vector3(0, speed * delta, 0))

	time_elapsed += delta
	if time_elapsed > 1.0:
		queue_free()
