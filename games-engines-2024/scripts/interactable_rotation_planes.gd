extends Node3D

@export var highlighted_plane:Node3D = null
@export var default_material:StandardMaterial3D = null
@export var highlighted_material:StandardMaterial3D = null

var plane_mesh_path = 'hingeOrigin/InteractableHinge/rotation_plane_body/body_mesh'

var tweening = false
var horizontal_plane_index = 0
var horizontal_planes = ['bottom_horizontal_plane', 'middle_horizontal_plane', 'top_horizontal_plane']
#var horizontal_planes = ['top_horizontal_plane']

var vertical_plane_index = 0
var vertical_planes = ['bottom_vertical_plane', 'middle_vertical_plane', 'top_vertical_plane']

var face_plane_index = 0
var face_planes = ['bottom_face_plane', 'middle_face_plane', 'top_face_plane']

var highlighted_plane_type = 'HORIZONTAL'

var planes = [
	'bottom_horizontal_plane', 'middle_horizontal_plane', 'top_horizontal_plane',
	'left_vertical_plane', 'middle_vertical_plane', 'right_vertical_plane',
	'front_face_plane', 'middle_face_plane', 'back_face_plane'
]

@onready var audioPlayer = $"../clickSound"
@onready var effects_bus_index = AudioServer.get_bus_index("effects_bus")

@export var hitzone: Area3D
	#'left_vertical_plane', 'middle_vertical_plane', 'right_vertical_plane',
	#'front_face_plane', 'middle_face_plane', 'back_face_plane'

# Called when the node enters the scene tree for the first time.
func _ready():
	set_default_materials()
	var parent = get_parent()
	#if(parent): 
		#parent.connect('left_ax_button_pressed', self.on_left_ax_click)
		#parent.connect('left_by_button_pressed', self.on_left_by_click)
		#parent.connect('right_ax_button_pressed', self.on_right_ax_click)
		#parent.connect('right_by_button_pressed', self.on_right_by_click)

var rotationType
func onSelect(emitted_nodes):
	#print('selected', emitted_nodes)
	#print(emitted_nodes[3].name)
	rotationType = emitted_nodes[3].name.split('_')[1]
	
	for plane in planes:
		get_node(plane).get_node(plane_mesh_path).set_surface_override_material(0, default_material)
		var hinge = get_node(plane).get_node('hingeOrigin/InteractableHinge')
		hinge.emit_signal('unselectableSignal')
	
	swap_highlighted_plane_new(emitted_nodes)

func onDeselect(area: Area3D):
	for plane in planes:
		get_node(plane).get_node(plane_mesh_path).set_surface_override_material(0, default_material)
		var hinge = get_node(plane).get_node('hingeOrigin/InteractableHinge')
		hinge.emit_signal('selectableSignal')
	
	for node in area.get_overlapping_bodies():
		if('Cubelet' in node.name):
			continue
		#node.get_node('../InteractableAreaButton').emit_signal('deselectSignal')
	hitzone.collision_layer = 2
	await get_tree().create_timer(0.05).timeout
	print(hitzone.get_overlapping_bodies())
	
#	Reset all effects here
	print()
	while AudioServer.get_bus_effect_count(effects_bus_index) > 0:
		print('Removing effect after rotation: ', AudioServer.get_bus_effect(effects_bus_index, 0))
		AudioServer.remove_bus_effect(effects_bus_index, 0)
		
	for item in hitzone.get_overlapping_bodies():
		var root = item.get_parent()
		if 'switch' in root.name and root.active:
			print('active')
#			Reactivate only effects that are in zone
			AudioServer.add_bus_effect(effects_bus_index, root.effect)


func onPlaySnapSound():
	audioPlayer.play()
	print('play sound here')
	
# TODO: Only set handle materials to be visible. Rotation area shouldn't be visible. 
func set_default_materials():
	for plane in planes:
		get_node(plane).get_node(plane_mesh_path).set_surface_override_material(0, default_material)
		var hinge = get_node(plane).get_node('hingeOrigin/InteractableHinge')
		hinge.connect('onSelectSignal', self.onSelect)
		hinge.connect('onDeselectSignal', self.onDeselect)
		hinge.connect('playSnapSound', self.onPlaySnapSound)

func swap_highlighted_plane_new(plane_nodes):
	plane_nodes[2].set_surface_override_material(0, highlighted_material)
	var rotationArea = plane_nodes[0]
	for node in rotationArea.get_overlapping_bodies():
		if('Cubelet' not in node.name):
			#node.get_node('../InteractableAreaButton').emit_signal('selectSignal')
			continue
		var old_transform = node.global_transform
		node.get_parent().remove_child(node)
		plane_nodes[1].add_child(node)
		node.global_transform = old_transform

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#TODO Obsolete
#func on_left_ax_click(): 
	#horizontal_plane_index -= 1
	#if(horizontal_plane_index < 0):
		#horizontal_plane_index = len(horizontal_planes) - 1
	#swap_highlighted_plane(horizontal_planes, horizontal_plane_index)
	#highlighted_plane_type = 'HORIZONTAL'
#
#func on_left_by_click(): 
	#horizontal_plane_index += 1
	#if(horizontal_plane_index > len(horizontal_planes) - 1):
		#horizontal_plane_index = 0	
	#swap_highlighted_plane(horizontal_planes, horizontal_plane_index)
	#highlighted_plane_type = 'HORIZONTAL'
	#
#func on_right_ax_click(): 
	#vertical_plane_index -= 1
	#if(vertical_plane_index < 0):
		#vertical_plane_index = len(vertical_planes) - 1
	#swap_highlighted_plane(vertical_planes, vertical_plane_index)
	#highlighted_plane_type = 'VERTICAL'
#
#func on_right_by_click(): 
	#vertical_plane_index += 1
	#if(vertical_plane_index > len(vertical_planes) - 1):
		#vertical_plane_index = 0	
	#swap_highlighted_plane(vertical_planes, vertical_plane_index)
	#highlighted_plane_type = 'VERTICAL'
