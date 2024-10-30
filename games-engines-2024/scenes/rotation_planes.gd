extends Node3D

@export var highlighted_plane:MeshInstance3D = null
@export var default_material:StandardMaterial3D = null
@export var highlighted_material:StandardMaterial3D = null

var horizontal_plane_index = 0
var horizontal_planes = ['bottom_horizontal_plane', 'middle_horizontal_plane', 'top_horizontal_plane']
# Called when the node enters the scene tree for the first time.
func _ready():
	set_default_materials()
	swap_highlighted_plane()

func set_default_materials():
	for plane in horizontal_planes:
		get_node(plane).set_surface_override_material(0, default_material)


func swap_highlighted_plane():
	print(horizontal_planes[horizontal_plane_index])
	highlighted_plane.set_surface_override_material(0, default_material)
	get_node(horizontal_planes[horizontal_plane_index]).set_surface_override_material(0, highlighted_material)
	highlighted_plane = get_node(horizontal_planes[horizontal_plane_index])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_just_pressed("down")):
		horizontal_plane_index -= 1
		if(horizontal_plane_index < 0):
			horizontal_plane_index = len(horizontal_planes) - 1
		print(horizontal_plane_index)
		swap_highlighted_plane()

	if(Input.is_action_just_pressed("up")):
		horizontal_plane_index += 1
		if(horizontal_plane_index > len(horizontal_planes) - 1):
			horizontal_plane_index = 0	
		print(horizontal_plane_index)
		swap_highlighted_plane()
