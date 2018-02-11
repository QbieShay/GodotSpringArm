extends KinematicBody

var SPEED = 5
var ANGLE_SPEED = 10

func _ready():
	get_node("../Spring").target = self
	pass

var fw = 0
var rot = 0 

func _input(event):
	if event.is_action_pressed( "ui_up" ):
		fw = 1.0
	if event.is_action_pressed( "ui_down" ):
		fw = -1.0
	if event.is_action_released( "ui_up" ) or event.is_action_released( "ui_down" ):
		fw = 0
	if event.is_action_pressed( "ui_right" ):
		rot  = -1.0
	if event.is_action_pressed( "ui_left" ):
		rot = 1
	if event.is_action_released( "ui_left" ) or event.is_action_released( "ui_right" ):
		rot = 0

func _process(delta):
	global_rotate( Vector3(0,1,0), rot * ANGLE_SPEED* delta)
	global_transform.origin += -global_transform.basis.z * SPEED * delta * fw