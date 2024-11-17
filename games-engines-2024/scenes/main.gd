extends Node3D

var xr_interface: XRInterface
@export var spawnPoint: Marker3D
@export var ballScene: PackedScene
var hitZone: Area3D
var hitTime = -1
var missTime = -1
var ball
@export var hoopMesh: MeshInstance3D

@export var hitMaterial: StandardMaterial3D
@export var missMaterial: StandardMaterial3D
@export var defaultMaterial: StandardMaterial3D

func _ready():
	xr_interface = XRServer.find_interface("OpenXR")
	
	if xr_interface and xr_interface.is_initialized():
		print("OpenXR initialized successfully")	
		
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		
		get_viewport().use_xr = true
	else:
		print("OpenXR not initialized")
		
	hitZone = get_node("Hoop/HitArea/HitZone")
	ball = ballScene.instantiate()
	add_child(ball)
	ball.global_position = spawnPoint.global_position
	
	hoopMesh.set_surface_override_material(0, defaultMaterial)
	
func _process(delta):
	var overlappingBodies = hitZone.get_overlapping_bodies()
	if(len(overlappingBodies) > 0):
		print('collision Detected')
		hitTime = Time.get_ticks_msec()
		hoopMesh.set_surface_override_material(0, hitMaterial)
		
	if(not hitTime == -1 and Time.get_ticks_msec() - 1000 >= hitTime):
		hitTime = -1
		hoopMesh.set_surface_override_material(0, defaultMaterial)
		ball.linear_velocity = Vector3.ZERO
		ball.global_position = spawnPoint.global_position
	elif(hitTime == -1 and missTime == -1 and ball.global_position.y < 0.05):
		hoopMesh.set_surface_override_material(0, missMaterial)
		missTime = Time.get_ticks_msec()
	
	if(not missTime == -1 and Time.get_ticks_msec() - 1000 >= missTime):
		missTime = -1
		hoopMesh.set_surface_override_material(0, defaultMaterial)
		ball.linear_velocity = Vector3.ZERO
		ball.global_position = spawnPoint.global_position
