extends OmniLight3D

var startPos = Vector3.ZERO
var pos1
var pos2
var lerp = 0.45

# Called when the node enters the scene tree for the first time.
func _ready():
	startPos = get_global_position()
	pos1= startPos
	pos1.x += 10
	pos2= startPos
	pos2.x -= 10
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = pos1.lerp(pos2, lerp)
	lerp += delta * 0.1
	
	if (lerp > 1):
		lerp = 0
	
	pass
