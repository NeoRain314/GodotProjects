extends Node

signal shop_changed

var contents = {}

func _ready() -> void:
	add_item("test_rod",1)
	add_item("diamond",3)

func add_item(item_id: String, amount: int = 1):
	if contents.has(item_id): contents[item_id] += amount	
	else:contents[item_id] = amount
	shop_changed.emit()

func remove_item(item_id: String, amount: int = 1):
	if contents.has(item_id): contents[item_id] -= amount
	if contents[item_id] >= 0: contents.erase(item_id)
	shop_changed.emit()
