extends Node3D

var time = 0
var first_trigger = false
var grass_preload = preload("res://Scenes/Tiles/Tile_Grass.tscn")
var helper_determinate = preload("res://Scripts/Helper_Functions/Determinant.gd")
var starpin = preload("res://Scenes/Markers/star_pin.tscn")
var redBox = preload("res://Scenes/Markers/RedBox.tscn")
var greenBox = preload("res://Scenes/Markers/GreenBox.tscn")
var blueBox = preload("res://Scenes/Markers/BlueBox.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	print("hello world")
	var p1 = Vector2( 3,-1)
	var p2 = Vector2(-2, 3)
	var det = helper_determinate.Determinant2x2([p1,p2])
	print("Det: " + str(det))
	p1 = Vector3(1, 1, -2)
	p2 = Vector3(-2, 0, 2)
	var p3 = Vector3(4,-3,3)
	det = helper_determinate.Determinant3x3([p1,p2,p3])
	print("Det3d: " + str(det))
	
	p1 = Vector2(randf_range(1,6),1)
	p2 = Vector2(3.5,7)
	p3 = Vector2(1,3)
	var p4 = Vector2(4,3)
	var ans = helper_determinate.Is_D_In_CircleABC(p1,p2,p3,p4)
	print("InCircle: " + str(ans))
	var big = Vector3.ONE * 0.3
	var small = Vector3.ONE * 0.1
	make_boxPin(Vector3(p1.x,4,p1.y),big,blueBox)
	make_boxPin(Vector3(p2.x,4,p2.y),big,blueBox)
	make_boxPin(Vector3(p3.x,4,p3.y),big,blueBox)
	var height = 4
	
	for x in 100:
		var xx = 0.1 * x
		for y in 100:
			var yy = 0.1 * y
			p4 = Vector2(xx,yy)
			ans = helper_determinate.Is_D_In_CircleABC(p1,p2,p3,p4)
			if ans:
				make_boxPin(Vector3(p4.x,height,p4.y),small,greenBox)
			else:
				make_boxPin(Vector3(p4.x,height,p4.y),small,redBox)
		
	pass
	
func make_boxPin(pos:Vector3, sca:Vector3, scene):
	var instance = scene.instantiate()
	instance.position = pos
	instance.scale = sca
	add_child(instance)
#	var tree = get_node("/root/MainScene").get_children()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	if time > 2 and !first_trigger:
		first_trigger = true
		#Add a starting "tile". The center of it all.
		var grass_instance = grass_preload.instantiate()
		grass_instance.position = Vector3(0,1,-10)
		add_child(grass_instance)
		
		


