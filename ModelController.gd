extends Node3D

var animation_speed = 1
var current_animation = ""

@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func set_speed(speed):
	animation_speed = speed
	animation_player.speed_scale = animation_speed
	
func set_running(speed):
	animation_player.current_animation = "run"
	set_speed(speed)
	
func set_standing():
	
	set_speed(1)
	animation_player.current_animation = "stand"
	
func set_jumping():
	set_speed(1)
	animation_player.current_animation = "jump"
	
func set_grinding():
	set_speed(1)
	animation_player.current_animation = "grind"
