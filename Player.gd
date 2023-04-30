extends CharacterBody3D

var turnPoints = 3

var is_dead = false

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var current_speed = 1
var current_movement_speed_vector = Vector3.ZERO
var maximum_speed = 3

var boosting = false
var current_stamina = 5
var max_stamina = 5

var look_direction = Vector3.FORWARD
var go_direction = Vector3.FORWARD

@onready var visual_model = $visual_origin
@onready var floor_raycast = $Raycast

@onready var charactermodel = $visual_origin/character_model

var fake_forward = Vector3.ZERO

var collision_normal = Vector3.UP
var normal_forward = Vector3.UP

var grinding = false
var grind_start_pos = Vector3.ZERO
var grind_end_pos = Vector3.ZERO
var current_grind_pos = Vector3.ZERO
var current_grind_distance = 0
var grind_dir = 1

var footstep_counter = 0
var footstep_limit = 1

var jump_cooldown = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	MarkerSpawns.player = self

func _physics_process(delta):
	if (is_dead):
		return
	
	jump_cooldown -= delta
	# Add the gravity.
	if (grinding):
		grind()
		pass
	
	if not is_on_floor():
		velocity.y -= gravity * delta



	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("forward", "back", "right", "left")
	#var rotate = Input.get_axis("ui_right", "ui_left")
	
	current_movement_speed_vector.x += input_dir.x * (0.05)
	current_movement_speed_vector.z += input_dir.y * (0.05)
	
	if (current_movement_speed_vector.length() > 1):
		current_movement_speed_vector = current_movement_speed_vector.normalized()
		
	if (current_movement_speed_vector):
		current_movement_speed_vector -= current_movement_speed_vector * 0.03
	
	current_speed = 1
	var stupid_animation = 1
	if (Input.is_action_just_pressed("boost")):
		boosting = true
	
	if (Input.is_action_just_released("boost")):
		boosting = false
		
	if (boosting):
		if (current_stamina > 0):
			current_stamina -= 0.02
			current_speed = 2
			stupid_animation = 1.3
		else:
			boosting = false
			
	if (!boosting):
		if (current_stamina < max_stamina):
			current_stamina += 0.019
			
	var _current_movement = current_movement_speed_vector * current_speed
	_current_movement = _current_movement.rotated(Vector3.UP, $camera_rotator.get_rotation().y)
	
	if is_on_floor():
		if ($jumpshape.disabled == false):
			var _pos = global_position
			_pos.y += 0.5
			global_position = _pos 
		
		$normalshape.disabled = false
		$jumpshape.disabled = true
	
		
		var _speed = _current_movement.length()
		
		footstep_counter += _speed * stupid_animation * 0.05
		if (footstep_counter > footstep_limit):
			footstep_counter = 0
			play_footstep()
		
		if (_speed < 0.2):
			charactermodel.set_standing()
			
		if (_speed > 0.2):
			charactermodel.set_running(_speed * stupid_animation)
	
		# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump()
	
	var direction = (transform.basis * Vector3(-_current_movement.z, 0, _current_movement.x))
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	#if rotate:
		#look_direction = look_direction.rotated(Vector3.UP, rotate * (0.01 * turnPoints))
		
	if is_on_floor():
		go_direction = look_direction
		
	look_at(transform.origin + go_direction)
	
	visual_model.look_at(visual_model.global_position - _current_movement.normalized())
	fake_forward = visual_model.basis.x
	ray()
	
	move_and_slide()

func jump():
	velocity.y = JUMP_VELOCITY
	charactermodel.set_jumping()
	$normalshape.disabled = true
	$jumpshape.disabled = false

func ray():
	if floor_raycast.is_colliding():
		collision_normal = floor_raycast.get_collision_normal()
		var across = Vector3.UP.cross(collision_normal)
		normal_forward = across.cross(collision_normal)
	pass
	
func start_grind(start_pos, end_pos):
	if jump_cooldown > 0:
		return
	
	if grinding:
		return
		
	var from = get_global_position()
	var to = start_pos
	
	var heading = from.direction_to(to).normalized()
	var dot = heading.dot(fake_forward.normalized())
	
	if dot > 0:
		grind_dir = 1
	else:
		grind_dir = -1
	
	grinding = true
	$sounds/grind.play()
	grind_start_pos = start_pos
	grind_end_pos = end_pos
	
	var distance_to = get_global_position().distance_to(start_pos)
	var dir = (end_pos - start_pos).normalized()
	
	current_grind_distance = distance_to
	var grind_lock_in_pos = start_pos + dir * current_grind_distance
	
	current_grind_pos = grind_lock_in_pos
	
	pass
	
func grind():
	if current_grind_distance > grind_start_pos.distance_to(grind_end_pos):
		grinding=false
		charactermodel.set_running(1)
		$sounds/grind.stop()
		jump_cooldown = 1
		return
		
	if (current_grind_distance < 0):
		grinding=false
		$sounds/grind.stop()
		charactermodel.set_running(1)
		jump_cooldown = 1
		return
	
	if (Input.is_action_just_pressed("jump")):
		grinding=false
		$sounds/grind.stop()
		charactermodel.set_jumping()
		jump_cooldown = 1
		jump()
		return
		
	var _pos = current_grind_pos
	_pos.y += 1
	global_position = _pos
	
	var grind_speed = 2.3
	var dir = (grind_end_pos - grind_start_pos).normalized()
	current_grind_distance += (grind_speed * 0.1) * grind_dir
	current_grind_pos = grind_start_pos + dir * current_grind_distance
	charactermodel.set_grinding()
	
	
	pass
	
func play_footstep():
	var rand = randi() % 4
	if rand == 0:
		$sounds/step1.play()
	if rand == 1:
		$sounds/step2.play()
	if rand == 2:
		$sounds/step3.play()
	if rand == 3:
		$sounds/step4.play()
	pass
	
func die():
	$sounds/electric.play()
	$Timer.start()
	is_dead = true
	
func _finish_death():
	#var simultaneous_scene = preload("res://ending.tscn").instantiate()
	get_tree().change_scene_to_file( "res://ending.tscn")
	pass

func _on_timer_timeout():
	_finish_death()
	pass # Replace with function body.
