extends OmniLight3D


# Called when the node enters the scene tree for the first time.
func _ready():
	MarkerSpawns.enemy_spawns = MarkerSpawns.enemy_spawns + [self]



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
