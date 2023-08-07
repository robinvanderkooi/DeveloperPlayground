extends RigidBody3D

var push_node : CSGBox3D
var pushed_countDown = 0.0
var original_material : StandardMaterial3D
var red_material : StandardMaterial3D

# Called when the node enters the scene tree for the first time.
func _ready():
	push_node = get_node("Push")
	original_material = push_node.material
	red_material = StandardMaterial3D.new()
	red_material.albedo_color = Color(1.5, 0, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if pushed_countDown > 0.0:
		pushed_countDown -= delta
		if pushed_countDown <=0.0:
			pushed_countDown = 0.0
			push_node.material = original_material
			
	


func PushMe():
	push_node.material = red_material
	pushed_countDown = .5
	var pushyParent = get_parent_node_3d()
	if pushyParent.has_method("PushButtonFunction"):
		pushyParent.PushButtonFunction()
	
