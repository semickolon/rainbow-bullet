extends CanvasLayer

onready var creditText = $CreditText
onready var credits = $Credits
onready var buttons = $Buttons
onready var logo = $Logo

func wait(s = 1):
	var t = Timer.new()
	t.set_wait_time(s)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")

func _ready():
	yield(wait(1), "completed")
	credits.queue_free()
	


func _on_Play_gui_input(event):
	if (event is InputEventMouseButton && event.pressed && event.button_index == 1):
		get_tree().change_scene("res://scenes/World.tscn")

func _on_Exit_gui_input(event):
	if (event is InputEventMouseButton && event.pressed && event.button_index == 1):
		get_tree().quit()
