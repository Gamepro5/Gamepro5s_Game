extends KinematicBody

var velocity = Vector3(0,0,0);
var upDef = Vector3(0, 1, 0)
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
			#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			rotate(Vector3.UP, deg2rad(-event.relative.x * sensitivity));
			eyes.rotate(Vector3.RIGHT, deg2rad(-event.relative.y * sensitivity));
			if eyes.get_rotation().x > PI/2:
				eyes.set_rotation(Vector3(PI/2, 0, 0))
			elif eyes.get_rotation().x < -PI/2:
				eyes.set_rotation(Vector3(-PI/2, 0, 0))
	
	if Input.is_action_pressed("unlock_cursor"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		cursorFocus = false;	
func _physics_process(delta):
	
	if velocity.x != 0 || velocity.z != 0:
		if !midAir:
			velocity.z *= 0.9;
			velocity.x *= 0.9;
			
		if abs(velocity.x) <= 0.0001:
			velocity.x = 0;
		if abs(velocity.z) <= 0.0001:
			velocity.z = 0;
			
	
	if !is_on_floor():
		#set_translation(Vector3(get_translation().x, 0, get_translation().z))
		acceleration = accelerationConstant * 0.15;
		velocity.y -= 0.1;
	else:
		velocity.y = 0;
		acceleration = accelerationConstant;
	print(is_on_floor())
	
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
	move_and_slide(velocity, upDef) #allways be moving
	
	if Input.is_action_pressed("unlock_cursor"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		cursorFocus = false;
		
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_FOCUS_IN:
		get_viewport().warp_mouse(Vector2(get_viewport().size.x/2,get_viewport().size.y/2))
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		cursorFocus = true;
		print("focus in")
	elif what == MainLoop.NOTIFICATION_WM_FOCUS_OUT:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		print("focus out")
