extends Node2D

var counter : int = 0
var _time: float
var shake_speed: int = 20
var max_shake: float = 0.5
var start_position_x: float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$splash.visible = false
	start_position_x = $rod.position.x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_time += delta
	
	if Input.is_action_just_pressed("ui_left"):
		#$rod.position.x = start_position_x
		counter += 1
		if counter > 2: counter = 0
		if counter == 0: $rod.play("idle")
		if counter == 1: $rod.play("fishing")
		if counter == 2: $rod.play("catch")
	
	if randi() % 50 == 0 && counter == 1:
		$splash.visible = true
		$splash.play("fishing")
		$splash.position.x = start_position_x - 17
	if counter == 2:
		$splash.visible = true
		$splash.play("catch")
		$splash.position.x = start_position_x - 26
		$rod.position.x = start_position_x + sin(_time * shake_speed) * max_shake
	
	if !$splash.is_playing(): $splash.visible = false
