extends Camera2D

onready var player := get_parent().get_node("Player")
var camera_zoom_types := [
	Vector2(.75, .75),
	Vector2(1, 1),
	Vector2(1.5, 1.5)
]
export var currentType := 1

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("zoom_in")):
		currentType = clamp(currentType-1, 0, 2)
	elif (event.is_action_pressed("zoom_out")):
		currentType = clamp(currentType+1, 0, 2)
		

func _process(delta: float) -> void:
	zoom = lerp(zoom, camera_zoom_types[currentType], 5*delta)
	position = lerp(position, player.position, 4*delta)
