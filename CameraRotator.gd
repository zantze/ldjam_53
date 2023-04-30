extends Node3D

var mouse_axis = Vector2.ZERO
var mouse_sensitivity = 1

@onready var camera = $camera_pitch

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass # Replace with function body.

func _process(delta):
	if (Input.is_key_pressed(KEY_ESCAPE)):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if (Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		

func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		mouse_axis = event.relative
		camera_rotation()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func camera_rotation():
	#if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		#return
		
	if mouse_axis.length() > 0:
		var horizontal = -mouse_axis.x * 0.1 * mouse_sensitivity
		var vertical = -mouse_axis.y * 0.1 * mouse_sensitivity
		mouse_axis = Vector2()
		rotate_y(deg_to_rad(horizontal))
		camera.rotate_x(deg_to_rad(vertical))
		var temp_rot = camera.rotation_degrees
		temp_rot.x = clamp(temp_rot.x, -75, 75)
		camera.rotation_degrees = temp_rot
	pass
