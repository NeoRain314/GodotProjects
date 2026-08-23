extends Node2D

enum State {
	IDLE,
	FISHING,
	ITEM_IN_NET,
	ITEM_CAUGHT
}

#fishes
var catched_items = []

#fishing net
var net_id = "test_net"
var shake_speed: int = 20
var max_shake: float = 0.5
var net_idle_pos: Vector2 = Vector2(0.0, 0.0) #global start pos has to be -7|-53!!!
var net_fishing_pos: Vector2 = Vector2(69.0, 31.0)
var fishing_time = ItemManagerAl.get_item(net_id).catch_time

var current_state: State = State.IDLE
var _time: float
var is_mouse_hovering: bool = false

@onready var net = $net
@onready var timer = $Timer
@onready var collisionshape_idel = $net/Area2D/CollisionShape_idel
@onready var collisionshape_fishing = $net/Area2D/CollisionShape_fishing


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	idle();


# ---- PROCESS -------------------------------------------------------------------------------------
func _process(delta: float) -> void:
	_time += delta
	
	if Input.is_action_just_pressed("mouse_click") && is_mouse_hovering:
		match current_state:
			State.IDLE:
				start_fishing()
			State.ITEM_IN_NET:
				fish_caught()
			State.ITEM_CAUGHT:
				collect_fish()
				idle()
	
	match current_state:
		State.FISHING:
			if randi() % 50 == 0: play_splash("fishing", -17)
		State.ITEM_IN_NET:
			play_splash("catch", -26)


# ---- STATE CONTROLLER ----------------------------------------------------------------------------
func set_state(new_state: State):
	current_state = new_state

func idle():
	set_state(State.IDLE)
	update_cursor()
	print("idle")
	net.play("idle")
	net.position = net_idle_pos
	collisionshape_fishing.disabled = true
	collisionshape_idel.disabled = false

func start_fishing():
	set_state(State.FISHING)
	update_cursor()
	timer.start(randi_range(fishing_time[0],fishing_time[1]))
	print("start fishing")
	net.play("fishing")
	net.position = net_fishing_pos
	collisionshape_fishing.disabled = false
	collisionshape_idel.disabled = true

func fish_on_rod():
	set_state(State.ITEM_IN_NET)
	update_cursor()
	print("fish in net")
	net.position = net_fishing_pos
	collisionshape_fishing.disabled = false
	collisionshape_idel.disabled = true

func fish_caught():
	set_state(State.ITEM_CAUGHT)
	print("fish caught")
	
	update_cursor()
	net.play("idle")
	net.position = net_idle_pos
	collisionshape_fishing.disabled = true
	collisionshape_idel.disabled = false

func collect_fish():
	InventoryManagerAl.add_item("2")
	print("collected")


# ---- HELPER FUNCTIONS ----------------------------------------------------------------------------
func play_splash(animation: String, offset_x: float = 0):
	pass

func update_cursor():
	if is_mouse_hovering:
		GameManagerAl.set_cursor(GameManagerAl.cursor_norm, "")
		match current_state:
			State.IDLE:
				GameManagerAl.set_cursor(GameManagerAl.cursor_select, "use")
			State.ITEM_IN_NET:
				GameManagerAl.set_cursor(GameManagerAl.cursor_select, "catch")
			State.ITEM_CAUGHT:
				GameManagerAl.set_cursor(GameManagerAl.cursor_select, "collect")				
	else:
		GameManagerAl.set_cursor(GameManagerAl.cursor_norm, "")

func pick_random_fish():
	if ItemManagerAl.rod_catchable_items.is_empty(): return null
	var total_weight:float = 0.0
	for fish_id in ItemManagerAl.rod_catchable_items:
		total_weight += ItemManagerAl.get_item(fish_id).weight
	var i: float = randf_range(0.0, total_weight)
	for fish_id in ItemManagerAl.rod_catchable_items:
		i -= ItemManagerAl.get_item(fish_id).weight
		if i <= 0.0: return fish_id

# ---- SIGNALS -------------------------------------------------------------------------------------
func _on_mouse_entered() -> void:
	is_mouse_hovering = true
	update_cursor()

func _on_mouse_exited() -> void:
	is_mouse_hovering = false
	update_cursor()

func _on_timer_timeout() -> void:
	set_state(State.ITEM_CAUGHT)
	fish_on_rod()
