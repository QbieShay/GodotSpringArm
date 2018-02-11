extends KinematicBody

var target setget assign_target
export var spring_max_length = 10
export var spring_max_height = 5
export var smoothness = 0.9
export var look_at_target = true
export var look_at_target_smoothness = 0.0 
export var rotate_with_target = true
export var rotate_with_target_smoothness = 0.0
export var angle_from_target_forward = -180.0

func _ready():
	if(target == null):
		set_physics_process(false)

func assign_target( t ):
	if (t == null):
		set_physics_process(false)
		return
	#TODO do stuff and enable process
	target = t
	set_physics_process(true)
	

func _physics_process(delta):
	#TODO use move_and_slide with angle -180 (math hacks wheeey)
	var target_forward = -target.global_transform.basis.z.normalized()
	var target_up = target.global_transform.basis.y.normalized()
	var camera_pos = target.global_transform.origin
	camera_pos += -target_forward*spring_max_length + target_up*spring_max_height
	var wanted_pos = global_transform.origin.linear_interpolate ( camera_pos, smoothness)
	move_and_slide( wanted_pos - global_transform.origin )
	#TODO smoothly look at target
	if(look_at_target):
		look_at(target.global_transform.origin, Vector3(0,1,0))