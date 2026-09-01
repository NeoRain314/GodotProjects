extends Node

signal change_scene_request(scene)

@onready var coin_label = $Coins/Label_Coins

func _ready() -> void:
	if GameManagerAl.previous_scene == GameManagerAl.scene_boat_trip: sell_items()

func _process(delta: float) -> void:
	coin_label.text = str(GameManagerAl.g_coins)  #better solution than in process !!!!!!!!!!

func sell_items():
	for item in ShopManagerAl.your_shop:
		var amount = ShopManagerAl.your_shop[item]
		GameManagerAl.g_coins += amount * ItemManagerAl.get_item(item).selling_price
		ShopManagerAl.remove_item(ShopManagerAl.your_shop, item, amount)
	

func _on_button_start_trip_pressed() -> void:
	change_scene_request.emit(GameManagerAl.scene_boat_trip)


func _on_button_game_shop_pressed() -> void:
	change_scene_request.emit(GameManagerAl.scene_game_shop)
