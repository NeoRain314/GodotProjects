extends Control

@export var inv_row_scene: PackedScene
@onready var container = $PanelContainer/MarginContainer/ScrollContainer/VBoxContainer


func _ready() -> void:
	InventoryManagerAl.inventory_changed.connect(update_inventory_ui) #connect so signal from inv manager
	update_inventory_ui()

func _process(delta: float) -> void:
	pass


func update_inventory_ui():
	for child in container.get_children():
		child.queue_free()
	for item_id in InventoryManagerAl.contents:
		var amount = InventoryManagerAl.contents[item_id]
		
		var row_instance = inv_row_scene.instantiate()
		container.add_child(row_instance)
		row_instance.setup(item_id, amount)

# --- old ---
#func update_inventory_ui():
	#var inv_text: String = "Inventory: \n"
	#for item_id in InventoryManagerAl.contents:
		#inv_text += "- " + item_id + ": " + str(InventoryManagerAl.contents[item_id]) + "\n"
	#$TempInventory.text = inv_text
