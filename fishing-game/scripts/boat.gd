extends Node2D

var sway_distance: int = 3
var sway_speed: int = 2

var sway_center_x : float
var max_tilt_degrees : int = 2
var _time : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sway_center_x = position.x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_time += delta
	position.x = sway_center_x + sin(_time * sway_speed) * sway_distance
	rotation = sin(_time * sway_speed) * deg_to_rad(max_tilt_degrees)
