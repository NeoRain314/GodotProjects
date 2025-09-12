extends CharacterBody2D


const SPEED = 50.0
const JUMP_VELOCITY = -210.0
var player_number: int = 1

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var direction = 1
var do_jump = false
var _is_on_floor = true

@export var player_id := 1:
	set(id):
		player_id = id
		%InputSynchronizer.set_multiplayer_authority(id)


# Stuff for collecting coins
@onready var coin_label: Label = $coin_label
@onready var display_coin_timer: Timer = $display_coin_timer
var coins = 0


func _ready() -> void:
	if multiplayer.get_unique_id() == player_id:
		$Camera2D.make_current()
	else:
		$Camera2D.enabled = false

func _apply_animations(delta):
	# Flip the Sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# Play animation
	if _is_on_floor:
		if direction == 0:
			animated_sprite.play("p" + str(player_number) + "_idle")
		else:
			animated_sprite.play("p" + str(player_number) + "_run")
	else:
		animated_sprite.play("p" + str(player_number) + "_jump")

func _apply_movement_from_input(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if do_jump and is_on_floor():
		velocity.y = JUMP_VELOCITY
		do_jump = false

	# Get the input direction: -1, 0, 1
	direction = %InputSynchronizer.input_direction
	
	
	
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


func _physics_process(delta: float) -> void:
	if multiplayer.is_server():
		_is_on_floor = is_on_floor()
		_apply_movement_from_input(delta)
		
	if not multiplayer.is_server() || MultiplayerManager.host_mode_enabled:
		_apply_animations(delta)






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
