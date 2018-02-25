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

var collision_info = null

func _ready():
	set_process(interpolate_physics_frames)
	physic_delta = get_physics_process_delta_time()
	previous_phys_position = global_transform.origin
	next_phys_position = global_transform.origin
	time_since_last_physic_process = 0 
	if(target == null):
		set_physics_process(false)
		set_process(false)

var time_since_last_physic_process = 0
func _process(delta):
	if(interpolate_physics_frames):
		#Interpolate between the last physic frame and the wanted one
		time_since_last_physic_process += delta
		global_transform.origin = previous_phys_position + (next_phys_position - previous_phys_position) * \
			clamp(time_since_last_physic_process/physic_delta,0,1)
	if(look_at_target):
		look_at(target.global_transform.origin, Vector3(0,1,0))

func set_interpolate_physics_frames(i):
	interpolate_physics_frames = i
	#set_process(i)

func get_interpolate_physics_frames():
	return interpolate_physics_frames

func assign_target( t ):
	if (t == null):
		set_physics_process(false)
		set_process(true)
		return
	#TODO do stuff and enable process
	target = t
	set_physics_process(true)
	set_process(true)

onready var _last_physics_position = global_transform.origin

var previous_phys_position
var next_phys_position
var physic_delta
func _physics_process(delta):
	time_since_last_physic_process = 0
	print(str(delta))
	var wanted_pos = _compute_movement()
	if(interpolate_physics_frames):
		#Use move and slide to calculate the right position and then move back
		previous_phys_position = global_transform.origin
		next_phys_position = previous_phys_position + move_and_slide( (wanted_pos - global_transform.origin)/delta )
		global_transform.origin = previous_phys_position
	else:
		move_and_slide( (wanted_pos - global_transform.origin)/delta )
	if(look_at_target):
		look_at(target.global_transform.origin, Vector3(0,1,0))

func _compute_movement():
	var target_forward = -target.global_transform.basis.z.normalized()
	var target_up = target.global_transform.basis.y.normalized()
	var camera_pos = target.global_transform.origin
	camera_pos += -target_forward*spring_max_length + target_up*spring_max_height
	return global_transform.origin.linear_interpolate(camera_pos, clamp(1-smoothness, 0.01,1))