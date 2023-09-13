extends Node3D

var points_node : Node3D
var point_scene = preload("res://Scenes/repulsion_point.tscn")
var rng = RandomNumberGenerator.new()
var starting_point_position : Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	points_node = get_node("../Points")
	starting_point_position = points_node.get_child(0).global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func PushButtonFunction():
	var instance = point_scene.instantiate()
	instance.position = starting_point_position + Vector3(rng.randf_range(-0.1, 0.1),rng.randf_range(-0.1, 0.1),rng.randf_range(-0.1, 0.1))
	points_node.add_child(instance)
	
