extends Node3D

@onready var interactable_slider = $SliderOrigin/InteractableSlider
@onready var sfxr_stream_player_3d = $SfxrStreamPlayer3D
@export var cube_scale:float
@export var hitzone: Area3D
@onready var frame = get_node("Frame")

signal deactivateSignal

# Called when the node enters the scene tree for the first time.
func _ready():
	#get_node("XRToolsInteractableArea").connect("pointer_event", self.onPointer)
	interactable_slider.connect("slider_moved", self.sliderMoved)
	connect("deactivateSignal", self.onDeactivate)
	pass # Replace with function body.

func onDeactivate():
	sfxr_stream_player_3d.stop()	

func sliderMoved(position):		
	if(position == 0):
		sfxr_stream_player_3d.stop()
	elif(not sfxr_stream_player_3d.playing):
		sfxr_stream_player_3d.play()
	 
	var output = remap(position, 0, 0.45, 600, 2200)
	sfxr_stream_player_3d.stream.mix_rate = output
	print(output)

func onPointer(event):
	print('pointer event: ', event)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
