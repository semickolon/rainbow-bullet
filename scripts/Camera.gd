# CLORO
extends Camera2D

onready var player := get_parent().get_node("Player")
var camera_zoom_types := [
	Vector2(.75, .75),
	Vector2(1, 1),
	Vector2(1.5, 1.5)
]

var focused_camera_zoom_types := [
	camera_zoom_types[0] * .8,
	camera_zoom_types[1] * .8,
	camera_zoom_types[2] * .8,
]
export var currentType := 1

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("zoom_in")):
		currentType = clamp(currentType-1, 0, 2)
	elif (event.is_action_pressed("zoom_out")):
		currentType = clamp(currentType+1, 0, 2)

func _process(delta: float) -> void:
	var type = focused_camera_zoom_types[currentType] if (Input.is_action_pressed("walk")) else camera_zoom_types[currentType]
	
	zoom = lerp(zoom, type, 5*delta)
	position = lerp(position, player.position, 4*delta)
