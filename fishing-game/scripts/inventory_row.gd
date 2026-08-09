extends HBoxContainer

@onready var item_icon = $TextureRect
@onready var item_name = $NameLabel
@onready var item_amount = $AmountLabel

func setup(item_id: String, amount: int):
	var item = ItemManagerAl.get_item(item_id)
	if item == null: push_warning("Item not fouond: " + item_id)
	item_icon.texture = item.texture
	item_name.text = item.name
	item_amount = "x" + str(amount)
