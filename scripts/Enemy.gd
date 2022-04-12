extends KinematicBody2D

export var ACCELRATION = 150
export var MAX_SPEED = 150
export var FRICTION = 200
export var WANDER_TARGET_RANGE = 4
var velocity = Vector2.ZERO


enum {
	IDLE,
	PATROL,
	CHASE
}

var state = CHASE

onready var playerDetection = $PlayerDetection
onready var Muzzle = $Muzzle
onready var time = $Muzzle/Timer


func _physics_process(delta):
	velocity = move_and_slide(velocity)
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			_seek_player()
			
		CHASE:
			var player = playerDetection.player
			var gun_type = "Pistol"
			if player != null:
				_accelerate_towards_point(player.global_position, delta)
				Muzzle.shoot(gun_type, "enemy")
			else:
				state = IDLE

func _accelerate_towards_point(point, delta):
	var player = playerDetection.player
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELRATION * delta)
	look_at(player.global_position)
	
func _seek_player():
	if playerDetection._can_see_player():
		state = CHASE
