extends Sprite2D

@onready var tile_map = $"../TileMap"


var is_moving = false

func _physics_process(delta): #smoothly move player
	if is_moving == false:
		return
	
	if global_position == $Sprite2D.global_position:
		is_moving = false
		return
	$Sprite2D.global_position = $Sprite2D.global_position.move_toward(global_position, 1)


func _process(delta):
	if is_moving:
		return
	
	if Input.is_action_pressed("move_up"):
		move(Vector2.UP)
	elif Input.is_action_pressed("move_down"):
		move(Vector2.DOWN)
	elif Input.is_action_pressed("move_left"):
		move(Vector2.LEFT)
	elif Input.is_action_pressed("move_right"):
		move(Vector2.RIGHT)
		
		
func move(direction: Vector2):
	var current_tile: Vector2i = tile_map.local_to_map(global_position)
	var target_tile: Vector2i = Vector2i(
		current_tile.x + direction.x,
		current_tile.y + direction.y,
	)
	var tile_data: TileData = tile_map.get_cell_tile_data(0, target_tile)
	
	
	if tile_data.get_custom_data("solid") == true:
		return
		
	$RayCast2D.target_position = direction * 16
	$RayCast2D.force_raycast_update()
	
	#if $Area2D.get_overlapping_areas():
	#	print($Area2D.get_overlapping_areas())

	if $RayCast2D.is_colliding():
		#print($RayCast2D.get_collider())
		var box = $RayCast2D.get_collider().get_parent()
		if box.canMove(direction) && checkAreaCanMove(direction):
			box._on_player_move_box(direction)
		else:
			return
	
	# move player ----------------------------------------
	is_moving = true
	
	global_position = tile_map.map_to_local(target_tile)
	
	$Sprite2D.global_position = tile_map.map_to_local(current_tile)

func checkAreaCanMove(direction): 
	if direction.x > 0:
		return $Area2D_right.get_overlapping_areas().size() == 0
	if direction.x < 0:
		return $Area2D_left.get_overlapping_areas().size() == 0
	if direction.y > 0:
		return $Area2D_down.get_overlapping_areas().size() == 0
	if direction.y < 0:
		return $Area2D_up.get_overlapping_areas().size() == 0
	return true
