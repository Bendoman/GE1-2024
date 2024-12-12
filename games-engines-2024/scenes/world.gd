extends Node3D

var xr_interface: XRInterface

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	xr_interface = XRServer.find_interface('OpenXR')
	
	if(xr_interface and xr_interface.is_initialized()):
		print('OpenXR initialized')
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		get_viewport().use_xr = true
	else:
		print('Failed to initialize OpenXR')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass