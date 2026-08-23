extends Node2D

enum State {
	IDLE,
	FISHING,
	ITEM_IN_NET,
	ITEM_CAUGHT
}

#fishes
var catched_item_ids = []


#fishing net
var net_id = "test_net"
var shake_speed: int = 20
var max_shake: float = 0.5
var net_idle_pos: Vector2 = Vector2(0.0, 0.0) #global start pos has to be -7|-53!!!  #TEMPORARY!!! (need better solution! :D)
var net_fishing_pos: Vector2 = Vector2(69.0, 31.0)
var fishing_time = ItemManagerAl.get_item(net_id).catch_time
var catch_slots = ItemManagerAl.get_item(net_id).catch_slots

var current_state: State = State.IDLE
var _time: float
var is_mouse_hovering: bool = false

@onready var net = $net
@onready var timer = $Timer
@onready var collisionshape_idel = $net/Area2D/CollisionShape_idel
@onready var collisionshape_fishing = $net/Area2D/CollisionShape_fishing
@onready var item_container = $ItemContainer


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
				item_caught()
			State.ITEM_CAUGHT:
				collect_items()
				idle()
	
	match current_state:
		State.FISHING:
			if randi() % 50 == 0: play_splash("fishing", -17)
		State.ITEM_IN_NET:
			net.position.x = net_fishing_pos.x + sin(_time * shake_speed) * max_shake


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

func item_in_net():
	set_state(State.ITEM_IN_NET)
	update_cursor()
	print("fish in net")
	net.position = net_fishing_pos
	collisionshape_fishing.disabled = false
	collisionshape_idel.disabled = true

func item_caught():
	set_state(State.ITEM_CAUGHT)
	print("fish caught")
	update_cursor()
	net.play("idle")
	net.position = net_idle_pos
	collisionshape_fishing.disabled = true
	collisionshape_idel.disabled = false
	
	catched_item_ids.clear()
	var item_count = randi_range(1, catch_slots)
	for i in item_count:
		catched_item_ids.append(pick_random_item())
	
	#show items
	var item_pos = Vector2i(-2,5)
	for item_id in catched_item_ids:
		var item = Sprite2D.new()
		item.texture = ItemManagerAl.get_item(item_id).texture
		item.position = item_pos
		item.set_meta("id", item_id)
		item_pos.x += 2
		item_pos.y -= 5
		item_container.add_child(item)

func collect_items():
	for item in item_container.get_children():
		InventoryManagerAl.add_item(item.get_meta("id"))
		var tween_item = item.create_tween().set_parallel(true) 
		tween_item.tween_property(item, "scale", Vector2(1.2,1.2), 0.3)
		tween_item.tween_property(item, "modulate:a", 0.0, 0.3)
		#tween_fish.tween_property(fish, "position:y", fish_default_prop["position"].y - 5, 0.3)
		tween_item.tween_property(item, "global_position", Vector2(get_viewport_rect().size.x, 0), 2)
		
		tween_item.chain().tween_callback(item.queue_free)
		
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

func pick_random_item():
	if ItemManagerAl.net_catchable_items.is_empty(): return null
	var total_weight: float = 0.0
	for item_id in ItemManagerAl.net_catchable_items:
		total_weight += ItemManagerAl.get_item(item_id).weight
	var i: float = randf_range(0.0, total_weight)
	for item_id in ItemManagerAl.net_catchable_items:
		i -= ItemManagerAl.get_item(item_id).weight
		if i <= 0.0: return item_id

# ---- SIGNALS -------------------------------------------------------------------------------------
func _on_mouse_entered() -> void:
	is_mouse_hovering = true
	update_cursor()

func _on_mouse_exited() -> void:
	is_mouse_hovering = false
	update_cursor()

func _on_timer_timeout() -> void:
	set_state(State.ITEM_CAUGHT)
	item_in_net()
