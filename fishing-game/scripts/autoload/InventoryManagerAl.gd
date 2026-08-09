extends Node

signal inventory_changed

var contents = {}

func _ready() -> void:
	pass 


func _process(delta: float) -> void:
	pass

func add_item(item_id: String, amount: int = 1):
	if contents.has(item_id): contents[item_id] += amount	
	else:contents[item_id] = amount
	inventory_changed.emit()
		

func remove_item(item_id: String, amount: int = 1):
	if contents.has(item_id): contents[item_id] -= amount
	if contents[item_id] >= 0: contents.erase(item_id)
	inventory_changed.emit()
