extends RigidBody3D


func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		apply_central_impulse(Vector3.UP * 50.0)
		return
	
	var input_dir := Vector3.ZERO
	if Input.is_action_pressed("ui_up"):
		input_dir.z += 1
	if Input.is_action_pressed("ui_down"):
		input_dir.z -= 1
	if Input.is_action_pressed("ui_left"):
		input_dir.x += 1
	if Input.is_action_pressed("ui_right"):
		input_dir.x -= 1
	
	input_dir = input_dir.normalized()
	
	apply_central_impulse(input_dir * 4.0)
