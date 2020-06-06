extends Spatial

func _on_Player_shoot(Bullet, direction, location):
	var b = Bullet.instance()
	add_child(b)
	b.rotation = direction
	b.position = location
	b.velocity = b.velocity.rotated(direction)
