extends Control

@export var shop_row_scene: PackedScene
@onready var shop_container = $VBoxContainer

@export var shop_bg_texture: Texture2D

func _ready() -> void:
	ShopManagerAl.shop_changed.connect(update_shop_ui)
	update_shop_ui(ShopManagerAl.your_shop)

func _process(delta: float) -> void:
	pass


func update_shop_ui(shop):
	print("update shop ui")
	for child in shop_container.get_children():
		child.queue_free()
	for item_id in shop:
		var amount = shop[item_id]
		
		var row_instance = shop_row_scene.instantiate()
		shop_container.add_child(row_instance)
		row_instance.setup(item_id, amount, 1)
