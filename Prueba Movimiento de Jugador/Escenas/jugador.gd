extends CharacterBody2D

@export var max_speed_base : float = 350
@export var max_speed_sprint : float = 550

@export var acceleration_base : float = 40
@export var acceleration_sprint : float = 45

var max_speed = max_speed_base
var acceleration = acceleration_base
@export var gravity : float = 1000
@export var jump_force : float = 400

var jump_buffer_counter : float = 0
@export var jump_buffer_time : float = 15

@export var double_jumps_max : int = 1
var double_jumps_available = double_jumps_max
var isgrounded = true

func _physics_process(_delta):

	# Linea de Debug para mostrar propiedades en el pj
	# $Label.text = "Speed: "  + str(velocity.x) + "\n Jump Buffer: " + str(jump_buffer_counter) + "\n IsOnWall: " + str(is_on_wall())

	if Input.is_key_pressed(KEY_SHIFT):
		max_speed = max_speed_sprint
		acceleration = acceleration_sprint
	else:
		max_speed = max_speed_base
		acceleration = acceleration_base

	if not is_on_floor():
		velocity.y += gravity * _delta

	if Input.is_action_pressed("ui_right"):
		if velocity.x < max_speed:
			velocity.x += acceleration
		$Sprite2D.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		if velocity.x > -max_speed:
			velocity.x -= acceleration
		$Sprite2D.flip_h = true
	elif is_on_floor():
		velocity.x = 0

	if Input.is_action_just_pressed("ui_select"):
		jump_buffer_counter = jump_buffer_time

	if jump_buffer_counter > 0:
		jump_buffer_counter -=1

	if jump_buffer_counter>0:
		if is_on_wall_only():
			jump_buffer_counter = 0 
			velocity.x = max_speed * direccion(get_wall_normal())
			velocity.y = -jump_force * 1.2
		elif is_on_floor_only():
			jump_buffer_counter = 0 
			velocity.y = -jump_force
		elif is_on_wall() and is_on_floor():
			jump_buffer_counter = 0 
			velocity.y = -jump_force * 1.2

	 #Cacho de codigo para detectar solamente cuando aterrizo en piso/pared y resetear los saltos. Esto detecta el 1er frame en donde todavía no se actualizo el isgrounded
	if isgrounded == false and (is_on_floor() or is_on_wall()):
		double_jumps_available = double_jumps_max
	isgrounded = (is_on_floor() or is_on_wall())
	

	if jump_buffer_counter>0 and double_jumps_available>0 and not is_on_wall() and not is_on_floor():
			jump_buffer_counter = 0 
			double_jumps_available -= 1
			velocity.y = -jump_force / 1.5 #  Los dobles saltos son menos potentes

	if Input.is_action_just_released("ui_select") and double_jumps_available>0: #Esta partecita la agrego pq quiero que los saltos dobles sean de una altura fija y no se puedan acortar.
		if velocity.y < 0:
			velocity.y += 200
	
	if velocity.x > max_speed:
		velocity.x += -acceleration
	if velocity.x < -max_speed:
		velocity.x += acceleration
	#velocity.x = clamp(velocity.x, max_speed*-1, max_speed)

	move_and_slide()


func direccion(dir: Vector2):
	match dir:
			Vector2(1,0):
				#print_debug("Izq")
				return 1
			Vector2(-1,0):
				#print_debug("der")
				return -1
	return 0

