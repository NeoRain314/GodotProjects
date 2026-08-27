extends Node

var g_coins = 20

var curr_cursor_asset = 0
var curr_cursor_text = ""

#cursors
var cursor_norm = load("res://assets/UI/cursors/cursor_0.png")
var cursor_select = load("res://assets/UI/cursors/cursor_1.png")
var cursor_click = load("res://assets/UI/cursors/cursor_2.png")

#scenes
var scene_boat_trip = preload("res://scenes/BoatTrip.tscn")
var scene_your_shop = preload("res://scenes/YourShop.tscn")

func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_cursor(type, text):
	curr_cursor_asset = type
	curr_cursor_text = text
	
