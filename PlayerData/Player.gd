extends KinematicBody

var velocity = Vector3(0,0,0);
var upDef = Vector3(0, 1, 0)
const accelerationConstant = 0.5;
var maxSpeed = 5;
var acceleration = 0;
var midAir = false;
var cursorFocus = false;
onready var eyes = get_node("Camera");
var sensitivity = 0.3;
var gravity = 25;
var jumpStrength = 10;
var flashlightOn = true;
var unshaded_material;
var shaded_material;

func _ready():
	eyes.set
	pass

func _physics_process(delta):
	midAir = !is_on_floor();
	
	if velocity.x != 0 || velocity.z != 0:
		if !midAir:
			velocity.z *= 0.9;
			velocity.x *= 0.9;
			
		if abs(velocity.x) <= 0.0001:
			velocity.x = 0;
		if abs(velocity.z) <= 0.0001:
			velocity.z = 0;
			
	
	if midAir:
		velocity.y = velocity.y - (gravity * delta);
		
		#set_translation(Vector3(get_translation().x, 0, get_translation().z))
		acceleration = accelerationConstant / 5;
	else:
		velocity.y = 0;
		acceleration = accelerationConstant;
	
	var velocityVector = Vector3(velocity.x, 0, velocity.z);
	#if the hypotenuse of the right triangle (overall velocity) is too long
	if (velocityVector.length() > maxSpeed):
		#shrink the triangle so that its hypotenuse is the max speed
		velocityVector = velocityVector.normalized();
		velocityVector.x *= maxSpeed;
		velocityVector.z *= maxSpeed;
		#set the velocities to the new legs of the triangle
		velocity.x = velocityVector.x;
		velocity.z = velocityVector.z;
		
		
		
