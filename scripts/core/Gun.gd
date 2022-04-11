extends Position2D
class_name Gun

var Bullet = preload("res://objects/Bullet.tscn")
enum GunTypes {Pistol, Shotgun, AssaultRifle, SniperRifle}

export(GunTypes) var type
var gun_owner = ""

func set_owner(path):
	gun_owner = path
	
func shoot(type):
	var b = Bullet.instance()
	owner.add_child(b)
	
	b.projectile_owner = gun_owner
	b.transform = global_transform
	b.init()
