extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$Control/Label2.text = "YOU MADE " + str(MarkerSpawns.deliveries)  + " AMOUNT OF DELIVERIES"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_button_button_up():
	MarkerSpawns.deliveries = 0
	get_tree().change_scene_to_file( "res://node_3d.tscn")
	for member in get_tree().get_nodes_in_group("enemy"):
		member.call_deferred("free")
	#get_tree().reload_current_scene()
	pass # Replace with function body.
