extends Node3D

@export var enabled = false

# Called when the node enters the scene tree for the first time.
func _ready():
	MarkerSpawns.markers = MarkerSpawns.markers + [self]
	
	if enabled:
		MarkerSpawns.currentMarker = self
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_body_entered(body):
	if enabled:
		if body.is_in_group("player"):
			marker_spawn()
	
func marker_spawn():
	enabled = false
	get_node("marker").hide()
	
	$zipper.play()
	
	get_tree().current_scene.get_node("Control/heat").value += 1
	
	var rand_index:int = randi() % MarkerSpawns.markers.size()
	print(rand_index)
	MarkerSpawns.markers[rand_index].enabled = true
	MarkerSpawns.markers[rand_index].get_node("marker").show()
	MarkerSpawns.currentMarker = MarkerSpawns.markers[rand_index]
	
	var enemy_spawn_pos = get_global_position()
	enemy_spawn_pos.y += 20
	var enemy_scene = load("res://ball_enemy.tscn")
	var instance = enemy_scene.instantiate()
	get_node("/root").add_child(instance)
	instance.global_position = enemy_spawn_pos
	MarkerSpawns.deliveries += 1
	get_tree().current_scene.get_node("Control/deliveries_done/count").text = "" + str(MarkerSpawns.deliveries)
	instance.max_speed = 5 + (MarkerSpawns.deliveries * 2.5)
	

	pass
