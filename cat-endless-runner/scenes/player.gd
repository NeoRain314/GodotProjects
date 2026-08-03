extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# gravity
	if is_on_floor():
		if not get_parent().game_running:
			$AnimatedSprite2D.play("idle")
			#print("idle")
		else:
			if Input.is_action_pressed("ui_accept"):
				velocity.y = JUMP_VELOCITY
			elif Input.is_action_pressed("ui_down"):
				$AnimatedSprite2D.play("duck") #duck animation
				#print("duck")
				$RunColision.disabled = true
			else:
				$AnimatedSprite2D.play("run") #run animation
				#print("run")
				$RunColision.disabled = false
	else:
		velocity += get_gravity() * delta
		$AnimatedSprite2D.play("jump") #jump animation
		#print("jump")

	move_and_slide()
