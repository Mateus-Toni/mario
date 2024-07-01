extends CharacterBody2D

var is_mounted = false
var yoshi : CharacterBody2D = null

const SPEED = 200.0
const JUMP_VELOCITY = -400.0
@onready var animated_sprite = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _process(delta):
	if is_mounted:
		mounted_movement()
	else:
		normal_movement()
		
	if Input.is_action_just_pressed("mount"):
		if is_mounted:
			dismount()
		else:
			find_and_mount()

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
		
	move_and_slide(direction * speed)

func mounted_movement():
	if mount:
		mount.move_and_slide(Vector2(velocity_x, velocity_y))

func find_and_mount():
	var mount_instance = get_tree().get_root().find_node("Mount", true, false)
	is_mounted = true
	animated_sprite.play("mounted")
	


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
