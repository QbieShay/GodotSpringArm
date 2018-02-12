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

export var interpolate_physics_frames = true setget set_interpolate_physics_frames, get_interpolate_physics_frames

func _ready():
	set_process(interpolate_physics_frames)
	if(target == null):
		set_physics_process(false)

func _process(delta):
	var wanted_pos = _compute_movement()
	
	global_transform.origin += (wanted_pos - global_transform.origin) * delta
	
	#TODO smoothly look at target
	if(look_at_target):
		look_at(target.global_transform.origin, Vector3(0,1,0))

func set_interpolate_physics_frames(i):
	interpolate_physics_frames = i
	set_process(i)

func get_interpolate_physics_frames():
	return interpolate_physics_frames

func assign_target( t ):
	if (t == null):
		set_physics_process(false)
		return
	#TODO do stuff and enable process
	target = t
	set_physics_process(true)

onready var _last_physics_position = global_transform.origin

func _physics_process(delta):
	
	if interpolate_physics_frames:
		global_transform.origin = _last_physics_position
		
	
	var wanted_pos = _compute_movement()
	
	move_and_slide( wanted_pos - global_transform.origin )
	
	_last_physics_position = global_transform.origin
	
	#TODO smoothly look at target
	if(look_at_target):
		look_at(target.global_transform.origin, Vector3(0,1,0))

func _compute_movement():
	#TODO use move_and_slide with angle -180 (math hacks wheeey)
	var target_forward = -target.global_transform.basis.z.normalized()
	var target_up = target.global_transform.basis.y.normalized()
	var camera_pos = target.global_transform.origin
	camera_pos += -target_forward*spring_max_length + target_up*spring_max_height
	return global_transform.origin.linear_interpolate(camera_pos, smoothness)