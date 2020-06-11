extends Spatial

var Bullet = preload("./Bullet/Bullet.tscn");

func shoot():
	var b = Bullet.instance()
	get_parent().add_child(b)
	b.translation = Vector3(translation.x, translation.y+1, translation.z);
	b.rotation = get_parent().global_transform.basis.get_euler();
	b.set_linear_velocity(get_parent().global_transform.basis.z*-25)
	
