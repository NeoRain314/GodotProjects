extends CharacterBody2D

var coins = 0

const SPEED = 50.0
const JUMP_VELOCITY = -210.0

@export var player_number: int = 1

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var coin_label: Label = $coin_label
@onready var display_coin_timer: Timer = $display_coin_timer


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("p" + str(player_number) + "_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction: -1, 0, 1
	var direction := Input.get_axis("p" + str(player_number) + "_move_left", "p" + str(player_number) + "_move_right")
	
	# Flip the Sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# Play animation
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("p" + str(player_number) + "_idle")
		else:
			animated_sprite.play("p" + str(player_number) + "_run")
	else:
		animated_sprite.play("p" + str(player_number) + "_jump")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	#move box
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		if collision.get_collider() is CharacterBody2D:
			var box = collision.get_collider()
			var push_force = velocity.x / 1.5
			box.velocity.x = push_force
	
	#move character
	move_and_slide()
	


var score = 0

func add_point():
	coins += 1
	print(coins)
	if coins == 1:
		coin_label.text = str(coins) + " coin"
	else:
		coin_label.text = str(coins) + " coins"
	display_coin_timer.start()



func _on_display_coin_timer_timeout() -> void:
	coin_label.text = ""
