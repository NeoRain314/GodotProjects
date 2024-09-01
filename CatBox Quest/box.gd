extends Sprite2D

var is_moving = false

func _physics_process(delta): #smoothly move player
	if is_moving == false:
		return
		
	if global_position == $BoxSprite2D.global_position:
		is_moving = false
		return
	$BoxSprite2D.global_position = $BoxSprite2D.global_position.move_toward(global_position, 1)

func _process(delta):
	pass


func _on_player_move_box(direction, solid):
	print("box")
	if solid:
		return

	var x = $BoxSprite2D.global_position
	global_position.x += direction.x * 16
	global_position.y += direction.y * 16
	$BoxSprite2D.global_position = x
	is_moving = true
