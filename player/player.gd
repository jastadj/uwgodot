extends KinematicBody

var _movement_input = Vector2()
var allow_movement = true
var _velocity = Vector3()
var _acceleration = Vector3()
var move_speed = 0.5
var move_speed_max = 5
var move_damp = 0.8
var gravity = -0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_pressed("ui_up"):
		_movement_input.y = -1
	elif Input.is_action_pressed("ui_down"):
		_movement_input.y = 1
	if Input.is_action_pressed("ui_left"):
		#_movement_input.x = -1
		rotation_degrees.y += 5
	elif Input.is_action_pressed("ui_right"):
		#_movement_input.x = 1
		rotation_degrees.y += -5

	if _movement_input != Vector2(0,0) and allow_movement:
		_movement_input.normalized()
		var forward = global_transform.basis.z
		var right = global_transform.basis.x
		var relative = (forward * _movement_input.y + right * _movement_input.x)
		
		var move_mod = 15
		#_acceleration.x = relative.x * move_speed
		#_acceleration.z = relative.z * move_speed
		_velocity.x = relative.x * move_speed * move_mod
		_velocity.z = relative.z * move_speed * move_mod
		#translation.x += _velocity.x
		#translation.z += _velocity.z
	else:
		# dampen velocity if not commanding movement (in the x and y)
		_velocity.x = _velocity.x * move_damp
		_velocity.z = _velocity.z * move_damp
		
	# add gravity
	_acceleration.y += gravity


	# apply acceleration to velocity
	_velocity = _velocity + _acceleration
	
	# terminal velocity
	_velocity.x = clamp(_velocity.x, -move_speed_max, move_speed_max)
	_velocity.z = clamp(_velocity.z, -move_speed_max, move_speed_max)
	
	
	# move player
	_velocity = move_and_slide(_velocity, Vector3.UP)
	
	
	_movement_input = Vector2()
	_acceleration = Vector3()
