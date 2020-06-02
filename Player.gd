extends KinematicBody

var velocity = Vector3(0,0,0);
const accelerationConstant = 0.5;
var maxSpeed = 0.04; 
var acceleration;
var midAir = false;
var cursorFocus = true;
onready var eyes = get_node("Camera");
var sensitivity = 0.3;

func _ready():
	
	pass

func _input(event):
	if event is InputEventMouseMotion:
		if cursorFocus:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			rotate(Vector3.UP, deg2rad(-event.relative.x * sensitivity));
			eyes.rotate(Vector3.LEFT, deg2rad(event.relative.y * sensitivity));
			if get_rotation().x > deg2rad(90): #workn't
				eyes.rotate(Vector3.LEFT, deg2rad(90))
			elif get_rotation().x < deg2rad(-90):
				eyes.rotate(Vector3.LEFT, deg2rad(-90))
		
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
		velocity.x -= sin(rotation.y) #* acceleration;
		velocity.z -= cos(rotation.y) #* acceleration;
	if Input.is_action_pressed("move_left"):
		#velocity.x = velocity.x - 1;
		velocity.x -= cos(rotation.y) #* acceleration;
		velocity.z += sin(rotation.y) #* acceleration;
	if Input.is_action_pressed("move_back"):
		#velocity.x = velocity.x + 1;
		velocity.x += sin(rotation.y) #* acceleration;
		velocity.z += cos(rotation.y) #* acceleration;
	if Input.is_action_pressed("move_right"):
		#velocity.z = velocity.z + 1;
		velocity.x += cos(rotation.y) #* acceleration;
		velocity.z -= sin(rotation.y) #* acceleration;
	if Input.is_action_pressed("turn_right"):
		rotate(Vector3.UP, -0.1)
	if Input.is_action_pressed("turn_left"):
		rotate(Vector3.UP, 0.1)
	move_and_slide(velocity)
	
	if Input.is_action_pressed("unlock_cursor"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		cursorFocus = false;
	#print(velocity)

	pass