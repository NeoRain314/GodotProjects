extends Node2D

var counter : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_left"):
		counter += 1
		if counter > 2: counter = 0
	if counter == 0: $AnimatedSprite2D.play("idle")
	if counter == 1: $AnimatedSprite2D.play("fishing")
	if counter == 2: $AnimatedSprite2D.play("catch")
