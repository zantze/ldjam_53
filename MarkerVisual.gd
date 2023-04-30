extends Node3D

@onready var visual1 = $Cylinder
@onready var visual2 = $Cylinder001
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	visual1.transform = visual1.transform.rotated(Vector3.UP, 1 * 0.01)
	visual2.transform = visual1.transform.rotated(Vector3.UP, -1 * 0.01)
	pass
