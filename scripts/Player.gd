extends KinematicBody2D

export (float) var speed = 325
var velocity = Vector2()

## Movement
func get_input():
	look_at(get_global_mouse_position())
	velocity = Vector2() # Clear Movement
	if (Input.is_action_pressed("move_up")):
		velocity = Vector2(speed, 0).rotated(rotation)
	if (Input.is_action_pressed("move_down")):
		velocity = Vector2(-speed, 0).rotated(rotation)
	if (Input.is_action_pressed("move_right")):
		velocity = Vector2(0, speed).rotated(rotation)
	if (Input.is_action_pressed("move_left")):
		velocity = Vector2(0, -speed).rotated(rotation)
	

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
