extends Node

signal shop_changed(shop)

var your_shop = {}

var game_shop = {}

func _ready() -> void:
	#add_item(your_shop, "diamond",3)
	pass

func add_item(shop, item_id: String, amount: int = 1):
	if shop.has(item_id): shop[item_id] += amount	
	else:shop[item_id] = amount
	shop_changed.emit(shop)

func remove_item(shop, item_id: String, amount: int = 1):
	if shop.has(item_id): shop[item_id] -= amount
	if shop[item_id] <= 0: shop.erase(item_id)
	shop_changed.emit(shop)
