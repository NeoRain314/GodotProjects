extends CharacterBody2D

var push_direction = Vector2.ZERO
const SPEED = 50.0 # Geschwindigkeit, mit der die Box geschoben wird
const FRICTION = 2 # Reibung, um die Box zu verlangsamen

func _physics_process(delta):
	#gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Box verlangsamen
	velocity.x = move_toward(velocity.x, 0, FRICTION)
	
	# Bewegung durch "move_and_slide"
	move_and_slide()
