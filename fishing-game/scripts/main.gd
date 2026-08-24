extends Node

#scenes
var boat_trip_scene = preload("res://scenes/BoatTrip.tscn")
var your_shop_scene = preload("res://scenes/YourShop.tscn")
var current_level_node = null



func _ready() -> void:
	#cursor
	GameManagerAl.set_cursor(GameManagerAl.cursor_norm, "")
	
	#load start scene
	load_your_shop()
	#load_boat_trip()

func _process(delta: float) -> void:
	pass


func load_boat_trip():
	if current_level_node != null:
		current_level_node.queue_free()
	current_level_node = boat_trip_scene.instantiate()
	add_child(current_level_node)

func load_your_shop():
	if current_level_node != null:
		current_level_node.queue_free()
	current_level_node = your_shop_scene.instantiate()
	add_child(current_level_node)
