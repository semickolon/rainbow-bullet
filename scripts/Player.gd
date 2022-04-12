# CLORO
extends KinematicBody2D
class_name Player

export(float) var default_speed = 325
export(float) var speed = 325
var core_movement_multiplier = 1

export(Vector2) var velocity := Vector2()

onready var Muzzle = $Muzzle
onready var camera = get_tree().get_current_scene().get_node("Camera")

export(String) var gun_type = "Pistol"

func combine_multipliers() -> float:
	return core_movement_multiplier

## Movement
func get_input() -> void:
	look_at(get_global_mouse_position())
	velocity = Vector2() # Clear Movement
	core_movement_multiplier = float(.65 if Input.is_action_pressed("walk") else 1)
	
	speed = default_speed * combine_multipliers()
	if (Input.is_action_pressed("move_up")):
		velocity = Vector2(speed, 0).rotated(rotation) if Input.is_action_pressed("world_movement") == false else Vector2(0, -speed)
	if (Input.is_action_pressed("move_down")):
		velocity = Vector2(-speed, 0).rotated(rotation) if Input.is_action_pressed("world_movement") == false else Vector2(0, speed)
	if (Input.is_action_pressed("move_right")):
		velocity = Vector2(0, speed).rotated(rotation) if Input.is_action_pressed("world_movement") == false else Vector2(speed, 0)
	if (Input.is_action_pressed("move_left")):
		velocity = Vector2(0, -speed).rotated(rotation) if Input.is_action_pressed("world_movement") == false else Vector2(-speed, 0)
	
## Shoot
func _input(event):
	if (Input.is_action_just_pressed("shoot")):
		Muzzle.shoot(gun_type, "player", 1500)

func _physics_process(delta: float) -> void:
	get_input()
	velocity = move_and_slide(velocity)
