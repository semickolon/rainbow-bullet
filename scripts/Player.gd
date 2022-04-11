extends KinematicBody2D
class_name Player

export(int) var speed := 325
export(Vector2) var velocity := Vector2()

onready var Muzzle = get_node("Muzzle")
export(String) var gun_type = "Pistol"

func _ready():
	Muzzle.set_owner(get_path())

## Movement
func get_input() -> void:
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
	
## Shoot
func _input(event):
	if (Input.is_action_just_pressed("shoot")):
		Muzzle.shoot(gun_type)

func _physics_process(delta: float) -> void:
	get_input()
	velocity = move_and_slide(velocity)
