extends Sprite2D
@export var debug_color_setting = 1
var is_moving = false

func _ready():
	$Area2D/CollisionShape2D.debug_color = debug_color_setting

func _physics_process(delta): #smoothly move player
	if is_moving == false:
		return
		
	if global_position == $BoxSprite2D.global_position:
		is_moving = false
		return
	$BoxSprite2D.global_position = $BoxSprite2D.global_position.move_toward(global_position, 1)

func _process(delta):
	pass


func _on_player_move_box(direction, box_can_move):
	print("box")
	if !box_can_move:
		pass
		#return

	var x = $BoxSprite2D.global_position
	global_position.x += direction.x * 16
	global_position.y += direction.y * 16
	$BoxSprite2D.global_position = x
	is_moving = true
