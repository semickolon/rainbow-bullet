# CLORO
extends Area2D
class_name Projectile

var BulletHit = preload("res://objects/vanity/BulletHit.tscn")
export var damage := 15
export var speed := 500
export var projectile_owner = ""

func explode():
	## Explosion Vanity
	var ex = BulletHit.instance()
	ex.position = position
	
	get_tree().get_current_scene().add_child(ex)
	ex.start()

func _ready() -> void:
	set_as_toplevel(true)
	connect("body_entered", self, "_on_body_entered")
	
func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta


func _on_body_entered(body: Node) -> void:
	if (body.is_in_group("projectiles")): return
	if (body.is_in_group("vanity")): return
	if (body.is_in_group("mobs") and projectile_owner == "enemy"): return
	if (body.is_in_group("player") and projectile_owner == "player"): return
	if (body.get_path() == projectile_owner): return
	
	explode()
	queue_free()
	
func init(projectile_type, _speed: int = speed, _damage: int = damage) -> void:
	projectile_owner = projectile_type
	damage = _damage
	speed = _speed
