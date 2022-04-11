# CLORO
extends Sprite

func start():
	var tween = get_node("Tween")
	tween.interpolate_property(self, "scale", Vector2(.65, .65), scale + Vector2(.5, .5), .25, Tween.TRANS_BACK, Tween.EASE_OUT)
	tween.interpolate_property(self, "modulate", modulate, Color(1, 1, 1, 0), .25, Tween.TRANS_BACK, Tween.EASE_OUT)
	tween.start()
	
func _on_Tween_tween_all_completed(object, key):
	queue_free()
