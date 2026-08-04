extends Node2D

var counter : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$smallSplash.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_left"):
		counter += 1
		if counter > 2: counter = 0
	if counter == 0: $AnimatedSprite2D.play("idle")
	if counter == 1: $AnimatedSprite2D.play("fishing")
	if counter == 2: $AnimatedSprite2D.play("catch")
	if randi() % 50 == 0 && counter != 0:
		$smallSplash.visible = true
		$smallSplash.play("default") #play different when catch animation or match position!!!!
		print("splash")
	if !$smallSplash.is_playing(): $smallSplash.visible = false
