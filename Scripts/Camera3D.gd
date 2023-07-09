extends Camera3D


@export var lerp_speed = 10
@export var target_path : NodePath = "../CharacterBody3D/Head"
@export var offset = Vector3.BACK + Vector3.UP
@export var offset_first = offset * 0.2
@export var first_lerp_speed = 15

var target = null

enum CAM_MODES {FIRST, SHOULDER}
var cam_mode : CAM_MODES = CAM_MODES.SHOULDER
var label_cam_mode : Label
var character_node : CharacterBody3D
var look_point_node : Node3D


func _ready():
	if target_path:
		target = get_node(target_path)
		label_cam_mode = get_node("/root/MainScene/CanvasLayer/Label_MapMode")
		character_node = get_node("../CharacterBody3D")
		look_point_node = get_node("../CharacterBody3D/Head/LookPoint")


func _physics_process(delta):
	if !target:
		return


	if cam_mode == CAM_MODES.SHOULDER:
		var target_xform = target.global_transform.translated_local(offset)
		global_transform = global_transform.interpolate_with(target_xform, lerp_speed * delta)
		
		look_at(target.global_transform.origin + (Vector3.UP * 0.5) + (Vector3.FORWARD * 0.05), Vector3.UP) #target.transform.basis.y)
	if cam_mode == CAM_MODES.FIRST:
		var target_xform = target.global_transform.translated_local(offset_first)
		global_transform = global_transform.interpolate_with(target_xform, first_lerp_speed * delta)
		
		look_at(look_point_node.global_transform.origin, Vector3.UP) #target.transform.basis.y)
		

#put a key press for switching the camera
func _input(event):
	if event.is_action_pressed("Camera"):
		if cam_mode == CAM_MODES.SHOULDER:
			cam_mode = CAM_MODES.FIRST
			label_cam_mode.text = "First"
			character_node.visible = false
		elif cam_mode == CAM_MODES.FIRST:
			cam_mode = CAM_MODES.SHOULDER
			label_cam_mode.text = "Shoulder"
			character_node.visible = true
