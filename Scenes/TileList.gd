extends Node3D

var time = 0
var first_trigger = false
var grass_preload = preload("res://Scenes/Tiles/Tile_Grass.tscn")
var helper_determinate = preload("res://Scripts/Helper_Functions/Determinant.gd")
var starpin = preload("res://Scenes/Markers/star_pin.tscn")
var redBox = preload("res://Scenes/Markers/RedBox.tscn")
var greenBox = preload("res://Scenes/Markers/GreenBox.tscn")
var blueBox = preload("res://Scenes/Markers/BlueBox.tscn")
var yellowBox = preload("res://Scenes/Markers/YellowBox.tscn")

var plane_y = 2.5
var plane_plane : Plane

var cam:Camera3D
var lookPoint:Node3D

var tilescene:PackedScene = preload("res://Scenes/Tiles/BaseTile.tscn")
var tileScenes:Array = Array() #

# Called when the node enters the scene tree for the first time.
func _ready():
	cam = get_node("/root/MainScene/Camera3D")
	lookPoint = get_node("/root/MainScene/CharacterBody3D/Head/LookPoint")
	
#	TEST_IsPointInCircle()
	var superPoints = TEST_MakeTheSuperTriangle(plane_y)
	plane_plane = Plane(superPoints[0],superPoints[1],superPoints[2])
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	if time > 2 and !first_trigger:
		first_trigger = true
		#Add a starting "tile". The center of it all.
		var grass_instance = grass_preload.instantiate()
		grass_instance.position = Vector3(0,1,-10)
		add_child(grass_instance)
		
func _input(event):
	if event.is_action_pressed("Shoot"):
		#fire the ray cast from the camera into a plane on the predefined height.
		var cam_position = cam.global_transform.origin
		var lookPoint_position = lookPoint.global_transform.origin
		var result = plane_plane.intersects_ray(cam_position, (lookPoint_position - cam_position).normalized() )
		if result != null:
			make_boxPin(result, Vector3.ONE * 0.2, blueBox)
			#Instanciate a new tile
			var newScene = tilescene.instantiate()
			var point_array:Array = Array()
			point_array.append(Vector3(0.4,0,0.4))
			point_array.append(Vector3(0.4,0,-0.4))
			point_array.append(Vector3(-0.4,0,0.4))
			point_array.append(Vector3(-0.4,0,-0.4))
			newScene.setup_mesh(point_array)
			newScene.position = result
			tileScenes.append(newScene)
			add_child(newScene)
		var asd = 123
		
func TEST_IsPointInCircle(): #call this in _ready to see it.
	#print("hello world")
	var p1 = Vector2( 3,-1)
	var p2 = Vector2(-2, 3)
	var det = helper_determinate.Determinant2x2([p1,p2])
	#print("Det: " + str(det))
	p1 = Vector3(1, 1, -2)
	p2 = Vector3(-2, 0, 2)
	var p3 = Vector3(4,-3,3)
	det = helper_determinate.Determinant3x3([p1,p2,p3])
	#print("Det3d: " + str(det))
	
	p1 = Vector2(randf_range(1,6),1)
	p2 = Vector2(3.5,7)
	p3 = Vector2(1,3)
	var p4 = Vector2(4,3)
	var ans = helper_determinate.Is_D_In_CircleABC(p1,p2,p3,p4)
	#print("InCircle: " + str(ans))
	var big = Vector3.ONE * 0.3
	var small = Vector3.ONE * 0.1
	make_boxPin(Vector3(p1.x,4,p1.y),big,blueBox)
	make_boxPin(Vector3(p2.x,4,p2.y),big,blueBox)
	make_boxPin(Vector3(p3.x,4,p3.y),big,blueBox)
	var height = 4
	
	#testing if a dot is in a circle.
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
	
func TEST_MakeTheSuperTriangle(height : float) -> Array:
	#Make 3 points as the start of the super triangle
	var pntScale = Vector3.ONE * 0.5
	var spread = 40
	var super1 = Vector3(-spread,height,spread)
	var super2 = Vector3(spread,height,spread)
	var super3 = Vector3(0,height,-spread)
	make_boxPin(super1,pntScale, redBox)
	make_boxPin(super2,pntScale, greenBox)
	make_boxPin(super3,pntScale, blueBox)

	#draw lines between them.
	var lineScale = Vector3.ONE * 0.2
	make_boxLine(super1, super2, lineScale, yellowBox)
	make_boxLine(super2, super3, lineScale, yellowBox)
	make_boxLine(super3, super1, lineScale, yellowBox)
	super2.direction_to(super3)
	
	#draw the triangle
	var tri:MeshInstance3D = MeshInstance3D.new()
	tri.mesh = TriangleMesh(super1, super2, super3, Vector3(0,-1,0)) #a backwards normal looked nicer
	#print(IsClockwise_positiveY(super1, super2, super3))
	var mat : Material = StandardMaterial3D.new()
	mat.albedo_color = Color(1.0,1.0,0.0,1.0)
	tri.set_surface_override_material(0,mat)
	add_child(tri)
	
	#Make a key to trigger adding a point.
	#Make the point be on the same plane as the super triangle.
	return [super1, super2, super3]

func TutorialMesh() -> Mesh:
	var st = SurfaceTool.new()

	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	# Prepare attributes for add_vertex.
	st.add_normal(Vector3(0, 0, 1))
	st.add_uv(Vector2(0, 0))
	# Call last for each vertex, adds the above attributes.
	st.add_vertex(Vector3(-1, -1, 0))

	st.add_normal(Vector3(0, 0, 1))
	st.add_uv(Vector2(0, 1))
	st.add_vertex(Vector3(-1, 1, 0))

	st.add_normal(Vector3(0, 0, 1))
	st.add_uv(Vector2(1, 1))
	st.add_vertex(Vector3(1, 1, 0))

	# Create indices, indices are optional.
	st.index()

	# Commit to a mesh.
	return st.commit()

func TriangleMesh(pntA:Vector3, pntB:Vector3, pntC:Vector3, nrml:Vector3) -> Mesh:
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	# Prepare attributes for add_vertex.
#	st.add_normal(Vector3(0, 0, 1))
#	st.add_uv(Vector2(0, 0))
	st.set_normal(nrml)
	st.add_vertex(pntA)

#	st.add_normal(Vector3(0, 0, 1))
#	st.add_uv(Vector2(0, 1))
	st.add_vertex(pntB)

#	st.add_normal(Vector3(0, 0, 1))
#	st.add_uv(Vector2(1, 1))
	st.add_vertex(pntC)

	st.index()

	return st.commit()

func make_boxPin(pos:Vector3, sca:Vector3, scene):
	var instance = scene.instantiate()
	instance.position = pos
	instance.scale = sca
	add_child(instance)
#	var tree = get_node("/root/MainScene").get_children()

func make_boxLine(posA:Vector3, posB:Vector3, sca:Vector3, scene):
	var instance = scene.instantiate()
	instance.position = (posA + posB)/2.0
	instance.scale = Vector3(sca)
	instance.scale.z = posA.distance_to(posB)
	add_child(instance)
	instance.look_at(posB)
	


func IsClockwise_positiveY(pntA:Vector3, pntB:Vector3, pntC:Vector3) -> bool:
	var pA = Vector3(pntA.x, pntA.z, 1)
	var pB = Vector3(pntB.x, pntB.z, 1)
	var pC = Vector3(pntC.x, pntC.z, 1)
	var det = helper_determinate.Determinant3x3([pA, pB, pC])
	return det > 0
