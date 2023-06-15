extends Camera3D


@export var lerp_speed = 10
@export var target_path : NodePath = "../CharacterBody3D/Head"
@export var offset = Vector3.BACK + Vector3.UP

var target = null

func _ready():
	if target_path:
		target = get_node(target_path)

func _physics_process(delta):
	if !target:
		return

	var target_xform = target.global_transform.translated_local(offset)
	global_transform = global_transform.interpolate_with(target_xform, lerp_speed * delta)

	look_at(target.global_transform.origin + (Vector3.UP * 0.5) + (Vector3.FORWARD * 0.05), Vector3.UP) #target.transform.basis.y)
