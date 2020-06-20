extends KinematicBody

var velocity = Vector3(0,0,0);
var upDef = Vector3(0, 1, 0)
const accelerationConstant = 0.5;
var maxSpeed = 5;
var acceleration = 0;
var midAir = false;
var cursorFocus = false;
var sensitivity = 0.3;
var gravity = 25;
var jumpStrength = 10;
var flashlightOn = true;
var unshaded_material;
var shaded_material;
var is_human;
onready var head = get_node("Head");
onready var eyes = head.get_node("Eyes");

var event = {
	move_front = false,
	move_left = false,
	move_back = false,
	move_right = false,
	jump = false,
	action_1 = false,
	
	#useless to bots
	lock_cursor = false,
	unlock_cursor = false,
}


signal shoot(weilder);

#how to send a signal to the gun child
	
func _ready():
	connect("shoot", head.get_node("Weapon").get_node("Gun"), "on_player_shoot") #gun
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
	movement_process(delta)
	if (is_human):
		if Input.is_action_pressed("lock_cursor"):
			#get_viewport().warp_mouse(Vector2(get_viewport().size.x/2,get_viewport().size.y/2))
			#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			cursorFocus = true;
		if Input.is_action_pressed("unlock_cursor"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			cursorFocus = false;
		if (cursorFocus):
			input_process(delta)
	move_and_slide(velocity, upDef) #allways be moving
	
func movement_process(_delta):
	if event.move_front:
		#velocity.z = velocity.z - 1;head.global_transform.basis.get_euler().y
		velocity.x -= sin(rotation.y) * acceleration;
		velocity.z -= cos(rotation.y) * acceleration;
	if event.move_left:
		#velocity.x = velocity.x - 1;
		velocity.x -= cos(rotation.y) * acceleration;
		velocity.z += sin(rotation.y) * acceleration;
	if event.move_back:
		#velocity.x = velocity.x + 1;
		velocity.x += sin(rotation.y) * acceleration;
		velocity.z += cos(rotation.y) * acceleration;
	if event.move_right:
		#velocity.z = velocity.z + 1;
		velocity.x += cos(rotation.y) * acceleration;
		velocity.z -= sin(rotation.y) * acceleration;
	if event.jump:
		if (!midAir):
			velocity.y = jumpStrength;
	if event.action_1:
		#get_viewport().warp_mouse(Vector2(get_viewport().size.x/2,get_viewport().size.y/2))
		if (head.get_node("Weapon").get_child_count() != 0):
			emit_signal("shoot", self)
			#print(head.translation)
			
func input_process(_delta):
	if Input.is_action_pressed("move_front"):
		event.move_front = true;
	else:
		event.move_front = false;
	if Input.is_action_pressed("move_left"):
		event.move_left = true;
	else:
		event.move_left = false;
	if Input.is_action_pressed("move_back"):
		event.move_back = true;
	else:
		event.move_back = false;
	if Input.is_action_pressed("move_right"):
		event.move_right = true;
	else:
		event.move_right = false;
	if Input.is_action_pressed("jump"):
		event.jump = true;
	else:
		event.jump = false;
	if Input.is_action_just_pressed("action_1"):
		event.action_1 = true;
	else:
		event.action_1 = false;