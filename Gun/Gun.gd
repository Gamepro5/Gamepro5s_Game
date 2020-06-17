extends Spatial

var Bullet = preload("./Bullet/Bullet.tscn");

func on_player_shoot(weilder):
	var b = Bullet.instance()
	b.add_collision_exception_with(weilder)
	#weilder.camera.add_render_exeption();
	get_tree().get_root().get_node("Level").add_child(b)
	print(weilder.global_transform.origin)
	print(weilder.get_node("Head").global_transform.origin)
	#print( to_global(weilder.get_node("Head").translation))
	b.translation = weilder.get_node("Head").global_transform.origin#to_global(weilder.get_node("Head").translation)#Vector3(weilder.translation.x, weilder.translation.y+1.925, weilder.translation.z) #1.925 is the y value of the head.
	b.rotation = weilder.get_node("Head").global_transform.basis.get_euler();
	b.set_linear_velocity(weilder.get_node("Head").global_transform.basis.z*-25)
	
