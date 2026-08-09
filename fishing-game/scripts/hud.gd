extends Node


func _ready() -> void:
	InventoryManagerAl.inventory_changed.connect(update_inventory_ui) #connect so signal from inv manager
	update_inventory_ui()

func _process(delta: float) -> void:
	pass

func update_inventory_ui():
	var inv_text: String = "Inventory: \n"
	for item_id in InventoryManagerAl.contents:
		inv_text += "- " + item_id + ": " + str(InventoryManagerAl.contents[item_id]) + "\n"
	$TempInventory.text = inv_text
