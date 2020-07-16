extends Camera

export(bool) var mouse_look = true
export(bool) var fly_mode = true


var sensitivity_x = 25
var sensitivity_y = 25
var invert_y = false
var _sensitivity_ce_x = .002
var _sensitivity_ce_y = .002

var _mouse_delta = Vector2()
var _movement_input = Vector2()

var _velocity = Vector3()
var move_speed = 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _process(delta):
	
	if Input.is_action_pressed("ui_up"):
		_movement_input.y = -1
	elif Input.is_action_pressed("ui_down"):
		_movement_input.y = 1
	if Input.is_action_pressed("ui_left"):
		_movement_input.x = -1
	elif Input.is_action_pressed("ui_right"):
		_movement_input.x = 1
	
	if _mouse_delta != Vector2(0,0) and mouse_look:
		var invert_mod = -1
		if invert_y: invert_mod = 1
		
		rotation_degrees.x += _mouse_delta.y * delta * sensitivity_x * invert_mod
		rotation_degrees.x = clamp(rotation_degrees.x, -90, 90)
		
		rotation_degrees.y += -_mouse_delta.x * delta * sensitivity_y
	
	if _movement_input != Vector2(0,0):
		
		if fly_mode:
			#var projection = project_ray_normal(get_viewport().get_mouse_position())
			var projection = project_ray_normal(Vector2(get_viewport().size * 0.5) )
			set_translation(Vector3(get_translation()+projection*delta*move_speed*200*(_movement_input.y*-1)) )
			pass
		else:
			_movement_input.normalized()
			var forward = global_transform.basis.z
			var right = global_transform.basis.x
			var relative = (forward * _movement_input.y + right * _movement_input.x)
			_velocity.x = relative.x * move_speed
			_velocity.z = relative.z * move_speed
			translation.x += _velocity.x
			translation.z += _velocity.z
	
	
	
	
	#_velocity = move_and_slide(_velocity, Vector3.UP)
	_mouse_delta = Vector2()
	_movement_input = Vector2()
		
		
func _input(event):
	
	if event is InputEventMouseMotion:
		_mouse_delta = event.relative

