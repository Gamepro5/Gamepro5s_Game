extends KinematicBody

var velocity = Vector3(0,0,0);
const accelerationConstant = 0.5;
var maxSpeed = 0.04; 
var acceleration;
var midAir = false;

func _ready():
	print(1-1-1);
	pass
	
	
func _physics_process(delta):
	
	if velocity.x != 0 || velocity.z != 0:
		if !midAir:
			velocity.z *= 0.9;
			velocity.x *= 0.9;
			
		if abs(velocity.x) <= 0.0001:
			velocity.x = 0;
		if abs(velocity.z) <= 0.0001:
			velocity.z = 0;
#	
#	if midAir:
#		acceleration = accelerationConstant * 0.15;
#	else:
#		acceleration = accelerationConstant;
		
	if Input.is_action_pressed("move_front"):
		#velocity.z = velocity.z - 1;
		velocity.x += sin(deg2rad(rotation_degrees.y)) #* acceleration;
		velocity.z += cos(deg2rad(rotation_degrees.y)) #* acceleration;
	if Input.is_action_pressed("move_left"):
		#velocity.x = velocity.x - 1;
		velocity.x += cos(deg2rad(rotation_degrees.y)) #* acceleration;
		velocity.z -= sin(deg2rad(rotation_degrees.y)) #* acceleration;
	if Input.is_action_pressed("move_right"):
		#velocity.x = velocity.x + 1;
		velocity.x -= sin(deg2rad(rotation_degrees.y)) #* acceleration;
		velocity.z -= cos(deg2rad(rotation_degrees.y)) #* acceleration;
	if Input.is_action_pressed("move_back"):
		#velocity.z = velocity.z + 1;
		velocity.x -= cos(deg2rad(rotation_degrees.y)) #* acceleration;
		velocity.z += sin(deg2rad(rotation_degrees.y)) #* acceleration;
	if Input.is_action_pressed("turn_left"):
		print("before turning left: %s" % rotation_degrees.y)
		rotation_degrees.y = rotation_degrees.y - 0.001
		print("after turning left: %s" % rotation_degrees.y)
	if Input.is_action_pressed("turn_right"):
		print("before turning right: %s" % rotation_degrees.y)
		rotation_degrees.y = rotation_degrees.y + 0.001
		print("after turning right: %s" % rotation_degrees.y)
	move_and_slide(velocity)
	#print(velocity)

	pass
