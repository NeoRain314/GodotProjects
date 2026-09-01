extends Node

signal change_scene_request(scene)

@onready var coin_label = $Label_YourCoins

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	coin_label.text = str(GameManagerAl.g_coins)  #better solution than in process !!!!!!!!!!


func _on_button_your_shop_pressed() -> void:
	change_scene_request.emit(GameManagerAl.scene_your_shop)
