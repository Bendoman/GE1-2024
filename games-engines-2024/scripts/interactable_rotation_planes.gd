extends Node3D

@export var highlighted_plane:Node3D = null
@export var default_material:StandardMaterial3D = null
@export var highlighted_material:StandardMaterial3D = null

var tweening = false
var horizontal_plane_index = 0
var horizontal_planes = ['bottom_horizontal_plane', 'middle_horizontal_plane', 'top_horizontal_plane']
#var horizontal_planes = ['top_horizontal_plane']

var vertical_plane_index = 0
var vertical_planes = ['bottom_vertical_plane', 'middle_vertical_plane', 'top_vertical_plane']

var face_plane_index = 0
var face_planes = ['bottom_face_plane', 'middle_face_plane', 'top_face_plane']

var highlighted_plane_type = 'HORIZONTAL'

# Called when the node enters the scene tree for the first time.
func _ready():
	set_default_materials()
	var parent = get_parent()
	if(parent): 
		parent.connect('left_ax_button_pressed', self.on_left_ax_click)
		parent.connect('left_by_button_pressed', self.on_left_by_click)
		parent.connect('right_ax_button_pressed', self.on_right_ax_click)
		parent.connect('right_by_button_pressed', self.on_right_by_click)

func on_left_ax_click(): 
	horizontal_plane_index -= 1
	if(horizontal_plane_index < 0):
		horizontal_plane_index = len(horizontal_planes) - 1
	swap_highlighted_plane(horizontal_planes, horizontal_plane_index)
	highlighted_plane_type = 'HORIZONTAL'

func on_left_by_click(): 
	horizontal_plane_index += 1
	if(horizontal_plane_index > len(horizontal_planes) - 1):
		horizontal_plane_index = 0	
	swap_highlighted_plane(horizontal_planes, horizontal_plane_index)
	highlighted_plane_type = 'HORIZONTAL'
	
func on_right_ax_click(): 
	vertical_plane_index -= 1
	if(vertical_plane_index < 0):
		vertical_plane_index = len(vertical_planes) - 1
	swap_highlighted_plane(vertical_planes, vertical_plane_index)
	highlighted_plane_type = 'VERTICAL'

func on_right_by_click(): 
	vertical_plane_index += 1
	if(vertical_plane_index > len(vertical_planes) - 1):
		vertical_plane_index = 0	
	swap_highlighted_plane(vertical_planes, vertical_plane_index)
	highlighted_plane_type = 'VERTICAL'


# TODO: Only set handle materials to be visible. Rotation area shouldn't be visible. 
func set_default_materials():
	for plane in horizontal_planes:
		get_node(plane).get_node('hingeOrigin/InteractableHinge/rotation_plane_body/body_mesh').set_surface_override_material(0, default_material)
	#for plane in vertical_planes:
		#get_node(plane).get_node('body_mesh').set_surface_override_material(0, default_material)
	#for plane in face_planes:
		#get_node(plane).get_node('body_mesh').set_surface_override_material(0, default_material)

# TODO: This should swap the highlighted plane group. Horizontal, Vertical, or Face. All will be set to selected and have their children set together.
func swap_highlighted_plane(planes_array, index):
	print(planes_array[index])
	highlighted_plane.get_node('hingeOrigin/InteractableHinge').emit_signal('onDeselectSignal')
	highlighted_plane.get_node('hingeOrigin/InteractableHinge/rotation_plane_body/body_mesh').set_surface_override_material(0, default_material)
	get_node(planes_array[index]).get_node('hingeOrigin/InteractableHinge/rotation_plane_body/body_mesh').set_surface_override_material(0, highlighted_material)
	highlighted_plane = get_node(planes_array[index])
	highlighted_plane.get_node('hingeOrigin/InteractableHinge').emit_signal('onSelectSignal')
	
	var rotationArea:Area3D = highlighted_plane.get_node('hingeOrigin/InteractableHinge/rotation_plane_body/body_mesh/RotationArea')
	
	for node in rotationArea.get_overlapping_bodies():
		if('Cubelet' not in node.name):
			continue
		print(node)
		var old_rotation = node.global_rotation
		var old_position = node.global_position
		node.get_parent().remove_child(node)
		highlighted_plane.get_node('hingeOrigin/InteractableHinge/rotation_plane_body').add_child(node)
		node.global_rotation = old_rotation
		node.global_position = old_position
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(highlighted_plane == null):
		highlighted_plane = get_node(horizontal_planes[0])
		swap_highlighted_plane(horizontal_planes, 0)


# TODO Obsolete:
func tween_rotation(deg):
	var tween = create_tween()
	var rotation_amount
	
	if(highlighted_plane_type == 'HORIZONTAL'):
		rotation_amount = Vector3(0, deg, 0)
	elif(highlighted_plane_type == 'VERTICAL' or highlighted_plane_type == 'FACE'):
		rotation_amount = Vector3(deg, 0, 0)
	tweening = true
	tween.connect("finished", on_tween_finish)
	tween.tween_property(highlighted_plane, "rotation_degrees", rotation_amount, .25).as_relative().set_trans(Tween.TRANS_SPRING)

# TODO Obsolete:
func on_tween_finish():
	tweening = false

# TODO Obsolete:
func _input(event):
	if(Input.is_action_just_pressed("down")):
		horizontal_plane_index -= 1
		if(horizontal_plane_index < 0):
			horizontal_plane_index = len(horizontal_planes) - 1
		swap_highlighted_plane(horizontal_planes, horizontal_plane_index)
		highlighted_plane_type = 'HORIZONTAL'

	if(Input.is_action_just_pressed("up")):
		horizontal_plane_index += 1
		if(horizontal_plane_index > len(horizontal_planes) - 1):
			horizontal_plane_index = 0	
		swap_highlighted_plane(horizontal_planes, horizontal_plane_index)
		highlighted_plane_type = 'HORIZONTAL'
		
	if(Input.is_action_just_pressed("left")):
		vertical_plane_index -= 1
		if(vertical_plane_index < 0):
			vertical_plane_index = len(vertical_planes) - 1
		swap_highlighted_plane(vertical_planes, vertical_plane_index)
		highlighted_plane_type = 'VERTICAL'

	if(Input.is_action_just_pressed("right")):
		vertical_plane_index += 1
		if(vertical_plane_index > len(vertical_planes) - 1):
			vertical_plane_index = 0	
		swap_highlighted_plane(vertical_planes, vertical_plane_index)
		highlighted_plane_type = 'VERTICAL'

	if(Input.is_action_just_pressed("in")):
		face_plane_index += 1
		if(face_plane_index > len(face_planes) - 1):
			face_plane_index = 0	
		swap_highlighted_plane(face_planes, face_plane_index)
		highlighted_plane_type = 'FACE'
		
	if(Input.is_action_just_pressed("out")):
		face_plane_index -= 1
		if(face_plane_index < 0):
			face_plane_index = len(face_planes) - 1
		swap_highlighted_plane(face_planes, face_plane_index)
		highlighted_plane_type = 'FACE'
		
		
	if(Input.is_action_just_pressed("turn_clockwise")):
		if(!tweening):
			tween_rotation(90)
		
	if(Input.is_action_just_pressed("turn_counter_clockwise")):
		if(!tweening):
			tween_rotation(-90)
