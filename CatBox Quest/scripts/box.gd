extends Sprite2D

@export var debug_color_setting = 1
@onready var tile_map = $"../TileMap"
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

#------------------------------------------------------------------------------------------------

func canMove(direction):
	
	var current_tile: Vector2i = tile_map.local_to_map(global_position)
	var target_tile: Vector2i = Vector2i(
		current_tile.x + direction.x,
		current_tile.y + direction.y,
		)
	var tile_data: TileData = tile_map.get_cell_tile_data(0, target_tile)

	if tile_data.get_custom_data("solid") == true:
		return false
	else:
		return true

func _on_player_move_box(direction):
	print("box")

	var x = $BoxSprite2D.global_position
	global_position.x += direction.x * 16
	global_position.y += direction.y * 16
	$BoxSprite2D.global_position = x
	is_moving = true
