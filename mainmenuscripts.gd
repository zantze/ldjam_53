extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	$character_model_standing/AnimationPlayer.play("stand2",-1, 0.5)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	get_tree().change_scene_to_file( "res://node_3d.tscn")
	pass # Replace with function body.
