extends Node3D

var convex_scrpt = preload("res://Scripts/Helper_Functions/2DConvexHull.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	#Setup
	var point_array : Array = Array()
	var randy:RandomNumberGenerator = RandomNumberGenerator.new()
	
	#My first go at this.
	var hmmm : CSGPolygon3D = get_node("CSGPolygon3D")
	var hmmm2 : CollisionPolygon3D = get_node("StaticBody3D/CollisionPolygon3D")
	
	#Gimmie points!
	point_array.clear()
	var number_of_points = 6
	for n in number_of_points:
		point_array.append( (Vector2.UP * randy.randf_range(0.8, 1.2) ).rotated(randy.randf_range(0, 360) * PI / 180.0) )

	hmmm.polygon = PackedVector2Array(convex_scrpt.Vector2ArrayToHull(point_array))
	hmmm2.polygon = hmmm.polygon


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


