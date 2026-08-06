extends Node2D

@export var fish_textures: Array[Texture2D] = [
	preload("res://assets/Fishes/fish_00.png"),
	preload("res://assets/Fishes/fish_01.png"),
	preload("res://assets/Fishes/fish_02.png"),
	preload("res://assets/Fishes/fish_03.png"),
	preload("res://assets/Fishes/fish_04.png"),
]

var stat : int = 0
var _time: float
var shake_speed: int = 20
var max_shake: float = 0.5
var start_position_x: float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$splash.visible = false
	$fish.visible = false
	start_position_x = $rod.position.x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_time += delta
	
	if Input.is_action_just_pressed("ui_left"):
		#$rod.position.x = start_position_x
		$fish.visible = false
		stat += 1
		stat = 3
		if stat > 3: stat = 0
		if stat == 0: idle() 
		if stat == 1: fishing()
		if stat == 2: catch()
		if stat == 3: fish_caught()
	
	if stat == 1 && randi() % 50 == 0:	
		$splash.visible = true
		$splash.play("fishing")
		$splash.position.x = start_position_x - 17
		
	if stat == 2:
		$splash.visible = true
		$splash.play("catch")
		$splash.position.x = start_position_x - 26
		$rod.position.x = start_position_x + sin(_time * shake_speed) * max_shake
	
	if !$splash.is_playing(): $splash.visible = false

func idle():
	$rod.play("idle")

func fishing():
	$rod.play("fishing")

func catch():
	$rod.play("catch")

func fish_caught():
	var fish_index: int = randi_range(0, fish_textures.size())
	print(fish_index)
	$rod.play("fish")
	set_fish_texture(fish_index)
	$fish.visible = true

func set_fish_texture(index: int):
	if index >= 0 && index < fish_textures.size():
		$fish.texture = fish_textures[index]


func _on_mouse_entered() -> void:
	pass
