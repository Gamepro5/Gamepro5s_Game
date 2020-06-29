extends RigidBody

var weilder; #holds the player so the bullet remembers who shot it out

func _ready():
	connect("body_entered", self, "on_body_entered")

func instance_ready(): #custom function since using _ready would trigger before an instance has been created, during preload.
	translation = weilder.get_node("Head").global_transform.origin;
	rotation = weilder.get_node("Head").global_transform.basis.get_euler();
	set_linear_velocity(weilder.get_node("Head").global_transform.basis.z*-25);
	set_contact_monitor(true)
	set_max_contacts_reported(10)#crutial!!

func on_body_entered(body):
	print("Hit detected @ ", body.name, " @ time = ", OS.get_time());
	if (body.get_filename() == "res://PlayerData/Player.tscn"):
		#print("Hit detected @ ", body.name, " @ time = ", OS.get_time());
		queue_free()
		#print("Hit detected @ ", body.name, " @ time = ", OS.get_time());
		body.health -= 20;
		if (body.health <= 0):
			body.kill()
