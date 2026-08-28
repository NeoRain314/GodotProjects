extends Node

#scenes --> in GameManager
var current_scene_node = null



func _ready() -> void:
	#cursor
	GameManagerAl.set_cursor(GameManagerAl.cursor_norm, "")
	
	#load start scene
	load_scene(GameManagerAl.scene_game_shop)

func _process(delta: float) -> void:
	pass

func load_scene(scene):
	if current_scene_node != null:
		current_scene_node.queue_free()
	current_scene_node = scene.instantiate()
	if current_scene_node.has_signal("change_scene_request"):
		current_scene_node.change_scene_request.connect(change_scene)
	add_child(current_scene_node)

func change_scene(scene):
	load_scene(scene)


#func load_boat_trip():
	#if current_level_node != null:
		#current_level_node.queue_free()
	#current_level_node = boat_trip_scene.instantiate()
	#add_child(current_level_node)
#
#func load_your_shop():
	#if current_level_node != null:
		#current_level_node.queue_free()
	#current_level_node = your_shop_scene.instantiate()
	#add_child(current_level_node)
