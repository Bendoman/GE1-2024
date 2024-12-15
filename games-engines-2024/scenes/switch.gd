extends Node3D

@export var defaultMaterial: StandardMaterial3D
@export var activeMaterial: StandardMaterial3D
@export var hitzone: Area3D

signal activateSignal
signal deactivateSignal

@onready var button_body:StaticBody3D = get_node('button')
@onready var button_mesh:MeshInstance3D = button_body.get_node('button')

const SWITCH_PRESSED = preload("res://materials/switch_pressed.tres")
const SWITCH_UNPRESSED = preload("res://materials/switch_unpressed.tres")

var active = false
func onHit():
	#if()
	print('switch bodies', hitzone.get_overlapping_bodies())
	
	active = !active
	if(active): 
		button_mesh.set_surface_override_material(0, SWITCH_PRESSED)
	else: 
		button_mesh.set_surface_override_material(0, SWITCH_UNPRESSED)


func onDrop():
	print('deactivated')



# Called when the node enters the scene tree for the first time.
func _ready():
	#connect("activateSignal", self.onActivate)
	#connect("deactivateSignal", self.onDeactivate)
	get_node('InteractableAreaButton').connect("hitSignal", self.onHit)
	#get_node('InteractableHandle').connect("droppedSignal", self.onDrop)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
