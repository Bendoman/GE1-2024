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
			
			var m = StandardMaterial3D.new()
			var h = ((row * col) + col) / (float)(rows * cols)
			m.albedo_color = Color.from_hsv(h, 1, 1)
			var mesh:MeshInstance3D = brick.get_node("brick2")
			mesh.set_surface_override_material(0, m)
			add_child(brick)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass # Replace with function body.
