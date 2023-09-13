extends StaticBody3D
var hull_helper = preload("res://Scripts/Helper_Functions/2DConvexHull.gd")


var neighbors : Array #An Array of neighboring BaseTiles
var id : int
#position would be on all Node3Ds already.

var myMeshInstance3D : MeshInstance3D
var myCollisionPolygon3D : CollisionPolygon3D

var isSetup = false

var delayed_setup:Array = Array()
var isReady = false

func setup_mesh(vector3_array:Array):
	if !isReady:
		delayed_setup = vector3_array
		return

	isSetup = true
	
	#vector3_array is a list of points
	var orderedSet = hull_helper.Vector3ArrayToHull(vector3_array)
	
	var center_point = Vector3.ZERO
	for v in orderedSet:
		center_point += v
	center_point /= orderedSet.size()
	center_point.y += 0.5
	var count = orderedSet.size()
	
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	for i in count:
		var j = i + 1
		if j >= count:
			j = 0
		var pl:Plane = Plane(orderedSet[i],orderedSet[j], center_point)
		st.set_normal(pl.normal)
		st.add_vertex(Vector3(orderedSet[i]))
		st.add_vertex(Vector3(orderedSet[j]))
		st.add_vertex(Vector3(center_point))
	st.index()
	myMeshInstance3D.mesh = st.commit()
	
#	st.add_normal(Vector3(0, 0, 1))
#	st.add_uv(Vector2(0, 0))
#	st.add_vertex(Vector3(-1, -1, 0))


# Called when the node enters the scene tree for the first time.
func _ready():
	isReady = true
	
	myMeshInstance3D = get_node("MeshInstance3D") # Replace with function body.
	myCollisionPolygon3D = get_node("CollisionPolygon3D")
	
	if delayed_setup.size() > 0 :
		setup_mesh(delayed_setup)
	
	if !isSetup:
		setup_mesh([
		Vector3(0,0,0),
		Vector3(0,0,1),
		Vector3(1,0,0),
		Vector3(1,0,1)])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
