extends Area2D

@export var speed = 100
var screen_size

var velocity
const tile_size = 18
var moving = false

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		move()
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		move()
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		move()
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		move()
		
	if velocity.length() > 0:
		#velocity = velocity.normalized() * speed
		#$AnimatedSprite2D.play()
		pass
	else:
		#$AnimatedSprite2D.stop()
		pass
		
	#position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		#$AnimatedSprite2D.animation = "walk"
		$Sprite2D.flip_v = false
		$Sprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		#$AnimatedSprite2D.animation = "up"
		$Sprite2D.flip_v = velocity.y > 0


func move():
	if velocity:
		if moving == false:
			moving = true
			var tween = create_tween()
			tween.tween_property(self, "position", position + velocity*tile_size, 0.35)
			tween.tween_callback(move_false)

func move_false():
	moving = false
		
