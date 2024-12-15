class_name SwitchXRToolsInteractableAreaButton
extends Area3D


## XR Tools Interactable Area Button script
##
## The interactable area button detects objects and areas intering its
## area, and moves an associated button object using a tween to animate
## the movement.


## Button pressed event
signal button_pressed(button)

## Button released event
signal button_released(button)

signal selectSignal
signal deselectSignal

signal hitSignal

## Button object
@export var button := NodePath()

## Displacement when pressed
@export var displacement : Vector3 = Vector3(0.0, -0.02, 0.0)

## Displacement duration
@export var duration : float = 0.1

@onready var hitzone: Area3D = get_node("..").hitzone

## If true, the button is pressed
var pressed : bool = false

## Dictionary of trigger items pressing the button
var _trigger_items := {}

## Tween for animating button
var _tween: Tween


# Node references
@onready var _button: Node3D = get_node(button)

# Button positions
@onready var _button_up := _button.transform.origin
@onready var _button_down := _button_up + displacement


# Add support for is_xr_class on XRTools classes
func is_xr_class(name : String) -> bool:
	return name == "XRToolsInteractableAreaButton"

@onready var switch_sound = $"../switch_sound"

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect area signals
	if area_entered.connect(_on_button_entered):
		push_error("Unable to connect button area signal")
	if area_exited.connect(_on_button_exited):
		push_error("Unable to connect button area signal")
	if body_entered.connect(_on_button_entered):
		push_error("Unable to connect button area signal")
	if body_exited.connect(_on_button_exited):
		push_error("Unable to connect button area signal")

	connect('button_pressed', self.onPress)
	connect('button_released', self.onRelease)
	connect('selectSignal', self.onSelect)
	connect('deselectSignal', self.onDeselect)

var selected: bool = false
func onSelect(): 
	#print('button set to selected')
	selected = true

func onDeselect():
	#print('button set to deselected')
	selected = false

func onPress(button):
	#emit_signal('play_sound', 'kick')
	#print('pressed')
	#print(hitzone.get_overlapping_bodies())
	#print(get_node("../button") in hitzone.get_overlapping_bodies())
	if(get_node("../button") in hitzone.get_overlapping_bodies()):
		switch_sound.play()
		emit_signal("hitSignal")

func onRelease(button):
	#print('released')
	pass

# Called when an area or body enters the button area
#TODO: Come back tot his
#var locked: bool = false
func _on_button_entered(item: Node3D) -> void:
	#print(item)
	# Add to the dictionary of trigger items
	_trigger_items[item] = item
	# Detect transition to pressed
	if !pressed:
		#var handle_pos = global_transform.origin
		#var dist = item.global_position.y - global_position.y
		#print(dist)
		#if dist < 0:
			#locked = true
			#print('locking')
			#return
			
		# Update state to pressed
		pressed = true

		# Kill the current tween
		if _tween:
			_tween.kill()

		# Construct the button animation tween
		_tween = get_tree().create_tween()
		_tween.set_trans(Tween.TRANS_LINEAR)
		_tween.set_ease(Tween.EASE_IN_OUT)
		_tween.tween_property(_button, "position", _button_down, duration)

		# Emit the pressed signal
		button_pressed.emit(self)

# Called when an area or body exits the button area
func _on_button_exited(item: Node3D) -> void:
	# Remove from the dictionary of triggered items
	_trigger_items.erase(item)
	
	#if(locked and _trigger_items.is_empty()):
		#locked = false
		#print('unlocking')

	# Detect transition to released
	if pressed and _trigger_items.is_empty():
		# Update state to released
		pressed = false

		# Kill the current tween
		if _tween:
			_tween.kill()

		# Construct the button animation tween
		_tween = get_tree().create_tween()
		_tween.set_trans(Tween.TRANS_LINEAR)
		_tween.set_ease(Tween.EASE_IN_OUT)
		_tween.tween_property(_button, "position", _button_up, duration)

		# Emit the released signal
		button_released.emit(self)


# Check button configuration
func _get_configuration_warnings() -> PackedStringArray:
	var warnings := PackedStringArray()

	# Ensure a button has been specified
	if not get_node_or_null(button):
		warnings.append("Button node to animate must be specified")

	# Ensure a valid duration
	if duration <= 0.0:
		warnings.append("Duration must be a positive number")

	return warnings