extends Control

@export var inv_row_scene: PackedScene
@onready var inv_container = $Inventory/MarginContainer/ScrollContainer/VBoxContainer
@onready var inv_panel =  $Inventory

var inventory_open: bool


func _ready() -> void:
	inv_panel.visible = false
	inventory_open = false
	inv_panel.pivot_offset = Vector2(inv_panel.size.x, 0)
	
	
	InventoryManagerAl.inventory_changed.connect(update_inventory_ui) #connect so signal from inv manager
	update_inventory_ui()

func _process(delta: float) -> void:
	pass


func update_inventory_ui():
	for child in inv_container.get_children():
		child.queue_free()
	for item_id in InventoryManagerAl.contents:
		var amount = InventoryManagerAl.contents[item_id]
		
		var row_instance = inv_row_scene.instantiate()
		inv_container.add_child(row_instance)
		row_instance.setup(item_id, amount)

func open_inventory():
	inv_panel.visible = true
	var tween = inv_panel.create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	inv_panel.scale = Vector2.ZERO
	tween.tween_property(inv_panel, "scale", Vector2.ONE, 0.4)
	inventory_open = true

func close_inventory():
	var tween = inv_panel.create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_property(inv_panel, "scale", Vector2.ZERO, 0.3)
	tween.tween_callback(inv_panel.hide)
	inventory_open = false

# --- old ---
#func update_inventory_ui():
	#var inv_text: String = "Inventory: \n"
	#for item_id in InventoryManagerAl.contents:
		#inv_text += "- " + item_id + ": " + str(InventoryManagerAl.contents[item_id]) + "\n"
	#$TempInventory.text = inv_text


func _on_inv_button_pressed() -> void:
	if inventory_open: close_inventory()
	else: open_inventory()
