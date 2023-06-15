extends Node3D

var map_mode = false
var map_mode_node : Label

# Called when the node enters the scene tree for the first time.
func _ready():
	map_mode_node = get_node("CanvasLayer/Label_MapMode")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event):
	if event is InputEventKey and event.is_pressed and event.keycode == KEY_ESCAPE:
		get_tree().quit()
	if event is InputEventKey and event.is_pressed and event.keycode == KEY_M:
		map_mode = !map_mode
		if map_mode:
			map_mode_node.text = "MM ON"
		else:
			map_mode_node.text = "MM OFF"
		
