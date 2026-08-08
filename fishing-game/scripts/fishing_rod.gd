extends Node2D

enum State {
	IDLE,
	FISHING,
	FISH_ON_ROD,
	FISH_CAUGHT
}

@export var fish_textures: Array[Texture2D] = [
	preload("res://assets/Fishes/fish_00.png"),
	preload("res://assets/Fishes/fish_01.png"),
	preload("res://assets/Fishes/fish_02.png"),
	preload("res://assets/Fishes/fish_03.png"),
	preload("res://assets/Fishes/fish_04.png"),
]
var fish_default_prop: Dictionary = {}

var shake_speed: int = 20
var max_shake: float = 0.5
var fishing_time = [0,0]

var current_state: State = State.IDLE

var _time: float
var rod_start_position_x: float
var is_mouse_hovering: bool = false

@onready var rod = $rod
@onready var splash = $splash
@onready var fish = $fish
@onready var timer = $Timer
@onready var collisionshape_fishing = $rod/Area2D/CollisionShape_fishing


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	splash.visible = false
	fish.visible = false
	fish_default_prop = {
		"scale": fish.scale,
		"modulate": fish.modulate,
		"position": fish.position
	}
	
	rod_start_position_x = rod.position.x
	collisionshape_fishing.disabled = true


# ---- PROCESS -------------------------------------------------------------------------------------
func _process(delta: float) -> void:
	_time += delta
	
	if !$splash.is_playing(): $splash.visible = false
	
	if Input.is_action_just_pressed("mouse_click") && is_mouse_hovering:
		match current_state:
			State.IDLE:
				start_fishing()
			State.FISH_ON_ROD:
				fish_caught()
			State.FISH_CAUGHT:
				collect_fish()
				idle()
	
	match current_state:
		State.FISHING:
			if randi() % 50 == 0: play_splash("fishing", -17)
		State.FISH_ON_ROD:
			rod.position.x = rod_start_position_x + sin(_time * shake_speed) * max_shake
			play_splash("catch", -26)


# ---- STATE CONTROLLER ----------------------------------------------------------------------------
func set_state(new_state: State):
	current_state = new_state

func idle():
	set_state(State.IDLE)
	rod.play("idle")
	update_cursor()
	collisionshape_fishing.disabled = true

func start_fishing():
	set_state(State.FISHING)
	rod.play("fishing")
	update_cursor()
	timer.start(randi_range(fishing_time[0],fishing_time[1]))
	collisionshape_fishing.disabled = false

func fish_on_rod():
	set_state(State.FISH_ON_ROD)
	rod.play("catch")
	update_cursor()
	collisionshape_fishing.disabled = false

func fish_caught():
	set_state(State.FISH_CAUGHT)
	rod.play("fish")
	rod.position.x = rod_start_position_x
	fish.texture = fish_textures.pick_random()
	fish.visible = true
	update_cursor()
	collisionshape_fishing.disabled = true

func collect_fish():
	var tween_fish = fish.create_tween().set_parallel(true) 
	tween_fish.tween_property(fish, "scale", Vector2(1.2,1.2), 0.3)
	tween_fish.tween_property(fish, "modulate:a", 0.0, 0.3)
	#tween_fish.tween_property(fish, "position:y", fish_default_prop["position"].y - 5, 0.3)
	tween_fish.tween_property(fish, "global_position", Vector2(get_viewport_rect().size.x, 0), 2)
	
	await tween_fish.finished
	for property in fish_default_prop:
		fish.set(property, fish_default_prop[property])
	fish.visible = false
	
	
	InventoryManagerAl.add_item("fish")

	

# ---- HELPER FUNCTIONS ----------------------------------------------------------------------------
func play_splash(animation: String, offset_x: float = 0):
	splash.visible = true
	splash.play(animation)
	splash.position.x = rod_start_position_x + offset_x

func update_cursor():
	if is_mouse_hovering:
		GameManagerAl.set_cursor(GameManagerAl.cursor_norm, "")
		match current_state:
			State.IDLE:
				GameManagerAl.set_cursor(GameManagerAl.cursor_select, "use")
			State.FISH_ON_ROD:
				GameManagerAl.set_cursor(GameManagerAl.cursor_select, "catch")
			State.FISH_CAUGHT:
				GameManagerAl.set_cursor(GameManagerAl.cursor_select, "collect")				
	else:
		GameManagerAl.set_cursor(GameManagerAl.cursor_norm, "")


# ---- SIGNALS -------------------------------------------------------------------------------------
func _on_mouse_entered() -> void:
	is_mouse_hovering = true
	update_cursor()


func _on_mouse_exited() -> void:
	is_mouse_hovering = false
	update_cursor()

func _on_timer_timeout() -> void:
	set_state(State.FISH_ON_ROD)
	fish_on_rod()
