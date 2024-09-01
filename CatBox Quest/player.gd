extends Sprite2D

signal moveBox

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
	# get current tile Vector2i
	var current_tile: Vector2i = tile_map.local_to_map(global_position)
	# get target tile Vector 2i
	var target_tile: Vector2i = Vector2i(
		current_tile.x + direction.x,
		current_tile.y + direction.y,
	)
	#prints(current_tile, target_tile)
	
	# get custom data layer from the target tile
	var tile_data: TileData = tile_map.get_cell_tile_data(0, target_tile)
	
	if tile_data.get_custom_data("solid") == true:
		return
		
	$RayCast2D.target_position = direction * 16
	$RayCast2D.force_raycast_update()

	if $RayCast2D.is_colliding():
		var box_target_tile: Vector2i = Vector2i(
			target_tile.x + direction.x,
			target_tile.y + direction.y,
		)
		var box_tile_data: TileData = tile_map.get_cell_tile_data(0, box_target_tile)
		var box_targed_tile_solid = false
		if box_tile_data.get_custom_data("solid") == true:
			box_targed_tile_solid = true
		
		moveBox.emit(direction, box_targed_tile_solid)
	
	# move player ----------------------------------------
	is_moving = true
	
	global_position = tile_map.map_to_local(target_tile)
	
	$Sprite2D.global_position = tile_map.map_to_local(current_tile)
	


	
	
	
