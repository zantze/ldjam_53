extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if MarkerSpawns.currentMarker == null:
		pass
	else:
		var direction = Vector3.ZERO
		direction.x = MarkerSpawns.currentMarker.get_global_position().x
		direction.z = MarkerSpawns.currentMarker.get_global_position().z
		direction.y = get_global_position().y
		look_at(direction)
	
	pass
