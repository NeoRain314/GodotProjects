extends Node

signal inventory_changed

var contents = {}

func _ready() -> void:
	pass 


func _process(delta: float) -> void:
	pass

func add_item(item_name: String, amount: int = 1):
	if contents.has(item_name): contents[item_name] += amount	
	else:contents[item_name] = amount
	inventory_changed.emit()
		

func remove_item(item_name: String, amount: int = 1):
	if contents.has(item_name): contents[item_name] -= amount
	if contents[item_name] >= 0: contents.erase(item_name)
	inventory_changed.emit()
