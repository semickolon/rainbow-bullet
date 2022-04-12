# CLORO
extends Position2D
class_name Gun

var Bullet = preload("res://objects/Bullet.tscn")
enum GunTypes {Pistol, Shotgun, AssaultRifle, SniperRifle}
onready var timer = $Timer

export(GunTypes) var type
	
func shoot(type, projectile_type, speed = 500):
	if (timer.is_stopped()):
		var b = Bullet.instance()
		owner.add_child(b)
		
		b.projectile_owner = projectile_type
		b.transform = global_transform
		if (projectile_type == "enemy"):
			var spread = PI * 0.175
			b.rotation += rand_range(-spread, spread)
		
		b.init(projectile_type, speed)
		timer.start()
