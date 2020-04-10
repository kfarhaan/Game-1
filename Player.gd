extends KinematicBody2D

const SPEED = 50
const GRAVITY = 10
const JUMP_POWER = -200
const FLOOR = Vector2(0, -1) #constant values cannot be reset once set

#once you've created the highkick animation and particle, use code below:
#const HIGHKICK = preload("res://HighKick.tscn") <- preloaded from wherever this file will be located
#const MIDKICK = preload("res://MidKick.tscn") <- preloaded from wherever this file will be located
#const LOWKICK = preload("res://LowKick.tscn") <- preloaded from wherever this file will be located

var velocity = Vector2() #Vector2 = a variable that takes two values (x, y)

var on_ground = false

var is_attacking = false

func _physics_process(delta):
	
	if Input.is_action_pressed("ui_right"):
		velocity.x = SPEED
		$AnimatedSprite.play("Run")
		$AnimatedSprite.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -SPEED
		$AnimatedSprite.play("Run")
		$AnimatedSprite.flip_h = true
	else:
			velocity.x = 0
			if on_ground == true:
				$AnimatedSprite.play("Idle")

	if Input.is_action_pressed("ui_up"):
		if is_attacking == false: #makes sure that you don't jump in the middle of an attack
			if on_ground == true: #trying to check condition, if it's actually equal
				velocity.y = JUMP_POWER
				on_ground = false
		if Input.is_action_just_released("ui_up") && velocity.y < -500:
			velocity.y = -500 #restricts jump height to 500 pixels

	if Input.is_action_just_pressed("ui_w") && is_attacking == false:
		is_attacking = true
		$AnimatedSprite.play("HighKick")
		#var HighKick = HIGHKICK.instance()
#Need to set up HighKickk animation and particles so this can be referenced

	velocity.y = velocity.y + GRAVITY #velocity.y += GRAVITY is a shorter way to write this

	if is_on_floor():
		on_ground = true
	else:
		if is_attacking == false:
			on_ground = false
			if velocity.y < 0:
				$AnimatedSprite.play("Jump")
			else:
				$AnimatedSprite.play("Fall")

	velocity = move_and_slide(velocity, FLOOR)
