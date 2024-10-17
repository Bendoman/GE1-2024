extends Node3D

@export var rows:int = 10
@export var cols:int = 10
@export var brick_scene:PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	for row in range(rows):
		for col in range(cols):
			var brick = brick_scene.instantiate()
			var pos = Vector3(col * 2, row * .5, 0)
#			For checkered effect
			if(row % 2 == 0):
				pos = Vector3(col * 2 - 1, row * .5, 0)

			brick.position = pos 
			add_child(brick)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass # Replace with function body.
