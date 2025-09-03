extends CharacterBody2D

@onready var name_label: Label = $nameLabel


const SPEED: float = 500.0
var username: String = ""

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _physics_process(delta: float) -> void:
	if !is_multiplayer_authority(): return
	
	velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * SPEED
	
	move_and_slide()

func _ready() -> void:
	#name_label.text = username
	name_label.text = username
	print(username)
