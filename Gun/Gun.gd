extends Spatial

var Bullet = preload("./Bullet/Bullet.tscn");

func on_player_shoot(weilder):
	print("sucess")
	var b = Bullet.instance()
	get_tree().get_root().get_node("Level").add_child(b)
	b.translation = Vector3(weilder.translation.x, weilder.translation.y+1, weilder.translation.z);
	b.rotation = weilder.get_node("Head").global_transform.basis.get_euler();
	b.set_linear_velocity(weilder.get_node("Head").global_transform.basis.z*-25)
	
