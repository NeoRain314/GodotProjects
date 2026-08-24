extends Control

@export var shop_row_scene: PackedScene
@onready var shop_container = $TextureRect/MarginContainer/ScrollContainer/VBoxContainer


func _ready() -> void:
	ShopManagerAl.shop_changed.connect(update_shop_ui)
	update_shop_ui()

func _process(delta: float) -> void:
	pass


func update_shop_ui():
	print("update shop ui")
	for child in shop_container.get_children():
		child.queue_free()
	for item_id in ShopManagerAl.contents:
		var amount = ShopManagerAl.contents[item_id]
		
		var row_instance = shop_row_scene.instantiate()
		shop_container.add_child(row_instance)
		row_instance.setup(item_id, amount)
