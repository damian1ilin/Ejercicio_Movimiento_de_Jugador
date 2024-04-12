extends CharacterBody2D

@export var max_speed : int = 500
@export var gravity : float = 2000
@export var jump_force : int = 500
@export var acceleration : int = 100

func _physics_process(_delta):
	if not is_on_floor():
		velocity.y += gravity * _delta
		#if velocity.y > 2000:
			#velocity.y = 2000

	if Input.is_action_pressed("ui_right"):
		if (velocity.x < 0):
			velocity.x = velocity.x * -1
		velocity.x += acceleration
		$Sprite2D.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		if (velocity.x > 0):
			velocity.x = velocity.x * -1
		velocity.x -= acceleration
		$Sprite2D.flip_h = true
	else:
		velocity.x = lerp(velocity.x,0.0,0.5)

	if Input.is_action_pressed("ui_select"):
		if is_on_floor():
			velocity.y = -jump_force
	
	velocity.x = clamp(velocity.x, max_speed*-1, max_speed)
	
	move_and_slide()
		
