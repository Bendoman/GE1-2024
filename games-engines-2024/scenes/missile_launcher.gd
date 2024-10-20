extends Node3D

@export var missile_scene:PackedScene = null;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event):
	if event.is_action_pressed("shoot"):
		var missile = missile_scene.instantiate()
		add_child(missile)		
		pass
	pass
