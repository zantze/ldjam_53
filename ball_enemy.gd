extends CharacterBody3D

var player
var speed = 1
var max_speed = 5
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("%Player")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player == null:
		player = MarkerSpawns.player
		return
	look_at(player.get_global_position())
	if (speed < max_speed):
		speed = speed + (delta * 0.3)
	velocity = -transform.basis.z * speed
	move_and_slide()
	pass
		

func _on_area_3d_body_entered(body):
	if(body.is_in_group("player")):
		body.die()
	pass # Replace with function body.
