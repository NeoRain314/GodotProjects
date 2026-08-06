extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	#GameManagerAl.set_cursor(load("res://assets/cursors/cursor_1.png"), "testtt")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = get_viewport().get_mouse_position()
	$Sprite2D.texture = GameManagerAl.curr_cursor_asset
	$Label.text = GameManagerAl.curr_cursor_text
