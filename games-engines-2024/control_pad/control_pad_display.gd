extends TabContainer


## Signal emitted when the control pad hand is switched
signal switch_hand(hand)

## Signal emitted when requested to go to the main scene
signal main_scene

## Signal emitted when requested to quit
signal quit


var _tween : Tween

var _player_body : XRToolsPlayerBody


# Called when the node enters the scene tree for the first time.
func _ready():
	# Apply initial scale
	#$Settings/VBoxContainer/Scale/BodyScaleSlider.value = XRServer.world_scale

	# Find the player body
	_player_body = XRToolsPlayerBody.find_instance(self)


# Called to refresh the display
func _on_refresh_timer_timeout():
	if _player_body and $Settings.visible:
		var pos := _player_body.global_position
		var vel := _player_body.velocity
		var pos_str := "%8.3f, %8.3f, %8.3f" % [pos.x, pos.y, pos.z]
		var vel_str := "%8.3f, %8.3f, %8.3f" % [vel.x, vel.y, vel.z]
		#$Body/VBoxContainer/Position/Value.text = pos_str
		#$Body/VBoxContainer/Velocity/Value.text = vel_str

# Handle user changing the body scale slider
func _on_body_scale_slider_value_changed(value : float) -> void:
	var index = AudioServer.get_bus_index("Master")
	
	AudioServer.set_bus_volume_db(index, linear_to_db(value))
	print(linear_to_db(value))

# Handle user selecting main scene
func _on_main_scene_pressed():
	main_scene.emit()

func _on_quit_pressed():
	quit.emit()

# Called by the tweening to change the world scale
func _set_world_scale(new_scale : float) -> void:
	XRServer.world_scale = new_scale