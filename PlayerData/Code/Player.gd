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

signal shoot(bullet, direction, location);

var Bullet = preload("res://LightPill.tscn");

func _ready():
	unshaded_material = eyes.get_node("Forearm").get_node("Pill").mesh.surface_get_material(0).duplicate()
	unshaded_material.flags_unshaded = true;
	shaded_material = eyes.get_node("Forearm").get_node("Pill").mesh.surface_get_material(0).duplicate()
	shaded_material.flags_unshaded = false;
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
		
	if Input.is_action_pressed("move_front"):
		#velocity.z = velocity.z - 1;
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
	if Input.is_action_pressed("action_1"):
		#get_viewport().warp_mouse(Vector2(get_viewport().size.x/2,get_viewport().size.y/2))
		print("attempted")
		emit_signal("shoot", Bullet, rotation, translation)
	move_and_slide(velocity, upDef) #allways be moving
	
	
	if Input.is_action_just_pressed("toggle_flashlight"):
		flashlightOn = !flashlightOn
		if flashlightOn:
			eyes.get_node("Forearm").get_node("Pill").mesh.surface_set_material(0, unshaded_material)
			eyes.get_child(0).light_energy = 2;
		else:
			eyes.get_node("Forearm").get_node("Pill").mesh.surface_set_material(0, shaded_material)
			eyes.get_child(0).light_energy = 0;
		#eyes.get_node("Forearm").get_node("Pill").mesh.surface_get_material(0).flags_unshaded = !(eyes.get_node("Forearm").get_node("Pill").mesh.surface_get_material(0).flags_unshaded); # this causes a collosal lag spike and I have no idea why.
		#eyes.get_child(0).light_energy = 0;
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
		
