extends CharacterBody2D

var is_mounted = false
var yoshi : CharacterBody2D = null

const SPEED = 200
const JUMP_VELOCITY = -400
@onready var animated_sprite = $AnimatedSprite2D
@onready var animated_sprite_yoshi = $AnimatedSprite2D
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var detection_area : Area2D

func _ready():
	animated_sprite = $AnimatedSprite2D
	detection_area = $Area2D
	


func _process(delta):
	if is_mounted:
		mounted_movement()
	else:
		normal_movement()

func normal_movement():
	var direction = Vector2()
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
		animated_sprite.play("walk")
		animated_sprite.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		direction.x -= 1
		animated_sprite.play("walk")
		animated_sprite.flip_h = true
	else:
		animated_sprite.play("idle")
		
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	elif Input.is_action_pressed("ui_up"):
		direction.y -= 1
	#move_and_slide()

func mounted_movement():
	if yoshi:
		var direction = Vector2()
		yoshi.move_and_slide()
		if Input.is_action_just_pressed("ui_right"):
			direction.x += 1
			animated_sprite_yoshi.play("walk")
		elif  Input.is_action_just_pressed("ui_left"):
			direction.x -= 1
			animated_sprite.flip_h = true
		else: 
			animated_sprite.play("mounted")

		if Input.is_action_just_pressed("ui_down"):
			direction.y += 1
		elif Input.is_action_just_pressed("ui_up"):
			direction.y -= 1	
		#yoshi.move_and_slide() # verificar o que faz rs

			
func mount ():
	if yoshi:
		is_mounted = true
		yoshi.get_node("AnimatedSprite2D").hide()
		
func dismount():
	if yoshi:
		is_mounted = false
		remove_child(yoshi)
		yoshi.get_node("PlayerSprite").show()
		yoshi = null


func decide_action(direction):
	
	if direction == -1:
		
		animated_sprite.flip_h = false
		if is_on_floor():
			animated_sprite.play("walk")
		
	elif direction == 1:
		
		animated_sprite.flip_h = true
		if is_on_floor():
			animated_sprite.play("walk")
		
	elif direction == 0:
		
		animated_sprite.play("idle")
		
	if not is_on_floor():
		
		animated_sprite.play("jump")
	
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	
	decide_action(direction)
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_area_2d_body_entered(body):
	if body.name == "yoshi" and not is_mounted:
		yoshi = body
		mount()
