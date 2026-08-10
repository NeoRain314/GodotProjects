extends PanelContainer

@onready var item_icon = $HBoxContainer/TextureRect
@onready var item_name = $HBoxContainer/NameLabel
@onready var item_amount = $HBoxContainer/AmountLabel

func setup(item_id: String, amount: int):
	var item = ItemManagerAl.get_item(item_id)
	if item == null: push_warning("Item not fouond: " + item_id)
	item_icon.texture = item.texture
	item_name.text = item.name
	item_amount.text = "x" + str(amount)
