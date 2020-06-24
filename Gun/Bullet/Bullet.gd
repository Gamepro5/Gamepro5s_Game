extends RigidBody
#extends OS

var weilder; #holds the player so the bullet remembers who shot it out

func instance_ready(): #custom function since using _ready would trigger before an instance has been created, during preload.
	translation = weilder.get_node("Head").global_transform.origin;
	rotation = weilder.get_node("Head").global_transform.basis.get_euler();
	set_linear_velocity(weilder.get_node("Head").global_transform.basis.z*-25);
	set_contact_monitor(true)
	set_max_contacts_reported(1)
	
func _physics_process(delta):
	var bodies = get_colliding_bodies();
	if (bodies.size() != 0):
		var target = bodies[0];
		#get_node("explosive_pill").visible = false;
		if (target.get_filename() == "res://PlayerData/player.tscn"):
			
			#sleeping = true;
			#get_node("explosive_pill").visible = false;
			#self.get_node("CollisionShape").disabled = true;
			
			print("Hit detected @ ", target.name, " @ time = ", OS.get_time());
			target.health -= 20;
			queue_free()
			print(target.health)
			if (target.health <= 0):
				target.kill();
			

