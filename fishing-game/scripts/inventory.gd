extends ScrollContainer

@onready var inv_container = $VBoxContainer
@export var inv_row_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	InventoryManagerAl.inventory_changed.connect(update_inventory_ui) #connect so signal from inv manager
	update_inventory_ui()


# Called every frame. 'delta' is the elapsed time since the previous frame.
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
