extends MultiplayerSynchronizer

@onready var player = $".."

var input_direction

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	if get_multiplayer_authority() != multiplayer.get_unique_id():
		set_process(false)
		set_physics_process(false)
	input_direction = Input.get_axis("p" + str(1) + "_move_left", "p" + str(1) + "_move_right")

func _physics_process(delta: float) -> void:
	input_direction = Input.get_axis("p" + str(1) + "_move_left", "p" + str(1) + "_move_right")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("p" + str(1) + "_jump"):
		jump.rpc()


@rpc("call_local")
func jump():
	if multiplayer.is_server():
		player.do_jump = true
