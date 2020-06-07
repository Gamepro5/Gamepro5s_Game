extends RigidBody

#var velocity = Vector3(0,0,0)


func _on_Player_shoot(Bullet, direction, location):
	var b = Bullet.instance()
	get_node("../").add_child(b)
	b.rotation = direction
	b.translation = location
	#b.translation.x = b.translation.x - 4
	#b._integrate_forces(b.add_force(Vector3(-50,0,0),Vector3(0,0,0))) Forces do not work.
	print("shot!")
	
#func _integrate_forces( state ):
#		print(2)
#		add_force(Vector3(-43,70,0), translation)
#		#state.linear_velocity = Vector3(-43,70,0)
