extends Node

signal change_scene_request(scene)

@onready var timer_label = $Panel/Label_Timer
@onready var timer = $Panel/Timer

func _ready() -> void:
	#timer.time_left = 10
	timer.start()

func _process(delta: float) -> void:
	timer_label.text = format_time(timer.time_left)

func _on_timer_timeout() -> void:
	change_scene_request.emit(GameManagerAl.scene_your_shop)

func format_time(seconds:float) -> String:
	var min: int = ceili(seconds)/60
	var sec: int = ceili(seconds)%60
	return "%02d:%02d" % [min, sec]
