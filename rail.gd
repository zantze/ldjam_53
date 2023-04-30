@tool
extends Node3D

@export var _calculate_hitboxes = false:
	set(value):
		calculate_hitboxes()

@onready var start = $start
@onready var end = $end

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func calculate_hitboxes():
	var start_pos = start.get_global_position()
	var end_pos = end.get_global_position()
	var distance = start_pos.distance_to(end_pos)
	

	
	var joints = get_node("joints")
	if joints != null:
		joints.set_owner(null)
		remove_child(joints)
	
	var parent = Node3D.new()
	parent.name="joints"
	add_child(parent) # Parent could be any node in the scene
	
	parent.global_position = start_pos
	
	var rolling_number = 0
	while distance > 0:
		var dir = (end_pos - start_pos).normalized()
		var pos = (dir * distance)
		
		print(pos)
		
		var node = Node3D.new()
		node.name="joint"
		node.position = pos
		var child_node = Area3D.new()
		child_node.add_to_group("rail", true)
		
		var box = CollisionShape3D.new()
		box.shape = BoxShape3D.new()
		
		child_node.add_child(box)
		node.add_child(child_node)
		parent.add_child(node)
		
		node.set_owner(get_tree().edited_scene_root)
		child_node.set_owner(get_tree().edited_scene_root)
		box.set_owner(get_tree().edited_scene_root)
		child_node.connect("body_entered", _player_entered_rail, ConnectFlags.CONNECT_PERSIST )
		
		distance = distance - 2
		rolling_number += 1

	# The line below is required to make the node visible in the Scene tree dock
	# and persist changes made by the tool script to the saved scene file.
	parent.set_owner(get_tree().edited_scene_root)

	pass

func _player_entered_rail(body):
	var start_pos = start.get_global_position()
	var end_pos = end.get_global_position()
	
	if body.is_in_group("player"):
		body.start_grind(start_pos, end_pos)
		
	pass
