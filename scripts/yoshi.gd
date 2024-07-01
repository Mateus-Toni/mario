extends CharacterBody2D

var mario : CharacterBody2D = null
var speed = 200

func _ready():
	# Referência ao mario
	mario = get_parent().get_node("mario")

func _process(delta):
	if mario and mario.is_mounted:
		# Lida com a lógica de movimento do yoshi aqui
		var direction = Vector2()
		if Input.is_action_pressed("ui_right"):
			direction.x += 1
			$AnimatedSprite2D.play("walk")
			$AnimatedSprite2D.flip_h = false
		elif Input.is_action_pressed("ui_left"):
			direction.x -= 1
			$AnimatedSprite2D.play("walk")
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.play("idle")
			
		if Input.is_action_pressed("ui_down"):
			direction.y += 1
		elif Input.is_action_pressed("ui_up"):
			direction.y -= 1
			
		velocity = direction * speed
		move_and_slide()
