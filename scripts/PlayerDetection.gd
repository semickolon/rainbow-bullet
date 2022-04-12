extends Area2D

var player = null
var angle_cone_of_vision = deg2rad(60.0)
var max_view_distance = 800.0
var angle_between_rays = deg2rad(10.0)
onready var ray = $RayCast2D

func _can_see_player():
	return player != null

func _on_PlayerDetection_body_entered(body):
	player = body

func _on_PlayerDetection_body_exited(body):
	player = null

func _physics_process(delta: float) -> void:
	var cast_count = int(angle_cone_of_vision / angle_between_rays) + 1
	
	for index in cast_count:
		var cast_vector = (
			max_view_distance
			* Vector2.UP.rotated(angle_between_rays * (index - cast_count / 2.0))
		)
		
		ray.cast_to = cast_vector
		ray.force_raycast_update()
		if ray.is_colliding() and ray.get_collider() == player:
			player = ray.get_collider()
			print("seen")
			break
