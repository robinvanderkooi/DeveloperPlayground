extends CharacterBody3D


var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var speed = 5
var jump_speed = 5
var mouse_sensitivity = 0.002

var target_node : Node
var camera_node : Camera3D
var label_node : Label

var grabbed : RigidBody3D = null
var starpin_scene = preload("res://Scenes/Markers/star_pin.tscn")
var starpin_instance_camera : Node3D = null
var starpin_instance_global : Node3D = null

func _ready():
	target_node = get_node("Head")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	#for the shoot function
	camera_node = get_node("../Camera3D")
	label_node = get_node("../CanvasLayer/Label")

func _physics_process(delta):
	velocity.y += -gravity * delta
	var input = Input.get_vector("left", "right", "forward", "back")
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y)
	velocity.x = movement_dir.x * speed
	velocity.z = movement_dir.z * speed

	move_and_slide()
	for col_idx in get_slide_collision_count():
		var col := get_slide_collision(col_idx)
		if col.get_collider() is RigidBody3D:
			col.get_collider().apply_central_impulse(-col.get_normal() * 0.3)
			col.get_collider().apply_impulse(-col.get_normal() * 0.01, col.get_position())

	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_speed
	
	if grabbed != null:
		#strait move
#		grabbed.position = (grabbed.position + starpin_instance_camera.global_position) / 2

		#move by force
		var force = (starpin_instance_camera.global_position - grabbed.global_position) * 80
		grabbed.apply_force(force)
		
		#Dampen the grabbed objects velocity
		grabbed.linear_velocity *= 0.8
		grabbed.angular_velocity *= 0.8

#		var newLocation = (grabbed_location + grabbed.position) / 2.0
#		grabbed.position = newLocation
#		grabbed_location = newLocation

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		target_node.rotate_x(-event.relative.y * mouse_sensitivity)
		if camera_node.cam_mode == 0: # First
			target_node.rotation.x = clampf(target_node.rotation.x, -1.45, 1.50)
			#target_node.rotation.x = clampf(target_node.rotation.x, -deg_to_rad(60), deg_to_rad(120))
		if camera_node.cam_mode == 1: # Shoulder
			target_node.rotation.x = clampf(target_node.rotation.x, -deg_to_rad(40), deg_to_rad(100))
	if event.is_action_pressed("Shoot"):
		shoot()
	if event.is_action_released("Shoot"):
		unshoot()

func shoot():
	print("shoot")
	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(camera_node.global_position,
			camera_node.global_position - camera_node.global_transform.basis.z * 100)
	query.exclude = [get_rid()]
	var collision = space.intersect_ray(query)
	if collision:
		label_node.text = collision.collider.name
		var objName = collision.collider.name
		if objName.begins_with("PushButton"):
			collision.collider.PushMe()
		var metaList = collision.collider.get_meta_list()
		if collision.collider.get_meta("isGrabable",false):
			grabbed = collision.collider
			
			
			#add to Camera
			var instance_camera = starpin_scene.instantiate()
			camera_node.add_child(instance_camera)
			instance_camera.position = instance_camera.to_local(collision.collider.position)
			instance_camera.set_scale(Vector3(0.2,0.2,0.2))
			starpin_instance_camera = instance_camera
			
			#add to World
			var instance_global = starpin_scene.instantiate()
			get_node("/root").add_child(instance_global)
			instance_global.position = collision.collider.position
			instance_global.set_scale(Vector3(0.2,0.2,0.2))
			starpin_instance_global = instance_global
			
			#grabbed_location = collision.position #might be shared, watch out for that.
	else:
		label_node.text = ""

func unshoot():
	if grabbed != null:
		print("unshoot")
		grabbed.apply_force(Vector3.UP)
		grabbed = null
		camera_node.remove_child(starpin_instance_camera)
		get_node("/root").remove_child(starpin_instance_global)

