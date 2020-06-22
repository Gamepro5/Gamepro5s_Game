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
var type = "player";
onready var head = get_node("Head");
onready var eyes = head.get_node("Eyes");

signal shoot(weilder);

#how to send a signal to the gun child

func _ready():

	connect("shoot", head.get_node("Weapon").get_node("Gun"), "on_player_shoot") #gun
	pass
	
func _input(event):
	if event is InputEventMouseMotion:
		if cursorFocus:
			rotate(Vector3.UP, deg2rad(-event.relative.x * sensitivity));
			head.rotate(Vector3.RIGHT, deg2rad(-event.relative.y * sensitivity));
			if head.get_rotation().x > PI/2:
				head.set_rotation(Vector3(PI/2, 0, 0))
				pass
			elif head.get_rotation().x < -PI/2:
				head.set_rotation(Vector3(-PI/2, 0, 0))
				pass
	
	if Input.is_action_pressed("unlock_cursor"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		cursorFocus = false;	
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
	if (cursorFocus):
		if Input.is_action_pressed("move_front"):
			#velocity.z = velocity.z - 1;head.global_transform.basis.get_euler().y
			velocity.x -= sin(rotation.y) * acceleration;
			velocity.z -= cos(rotation.y) * acceleration;
		if Input.is_action_pressed("move_left"):
			#velocity.x = velocity.x - 1;
			velocity.x -= cos(rotation.y) * acceleration;
			velocity.z += sin(rotation.y) * acceleration;
		if Input.is_action_pressed("move_back"):
			#velocity.x = velocity.x + 1;
			velocity.x += sin(rotation.y) * acceleration;
			velocity.z += cos(rotation.y) * acceleration;
		if Input.is_action_pressed("move_right"):
			#velocity.z = velocity.z + 1;
			velocity.x += cos(rotation.y) * acceleration;
			velocity.z -= sin(rotation.y) * acceleration;
		if Input.is_action_pressed("jump"):
			if (!midAir):
				velocity.y = jumpStrength;
		if Input.is_action_just_pressed("action_1"):
			#get_viewport().warp_mouse(Vector2(get_viewport().size.x/2,get_viewport().size.y/2))
			if (head.get_node("Weapon").get_child_count() != 0):
				emit_signal("shoot", self)
				#print(head.translation)
	move_and_slide(velocity, upDef) #allways be moving
	

	if Input.is_action_pressed("lock_cursor"):
		#get_viewport().warp_mouse(Vector2(get_viewport().size.x/2,get_viewport().size.y/2))
		#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		cursorFocus = true;
	if Input.is_action_pressed("unlock_cursor"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		cursorFocus = false;
	
	#print("tick = ", delta)
	#print(velocity)
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_FOCUS_IN:
		#get_viewport().warp_mouse(Vector2(get_viewport().size.x/2,get_viewport().size.y/2))
		#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		#cursorFocus = true;
		print("focus in")
	elif what == MainLoop.NOTIFICATION_WM_FOCUS_OUT:
		#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		print("focus out")
