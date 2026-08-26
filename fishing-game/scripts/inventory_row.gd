extends PanelContainer

enum RowType { INVENTORY, SHOP_BUY, SHOP_SELL }


@onready var item_icon = $HBoxContainer/Icon
@onready var item_name = $HBoxContainer/NameLabel
@onready var item_amount = $HBoxContainer/AmountLabel
@onready var item_price = $HBoxContainer/PriceLabel
@onready var coin_icon = $HBoxContainer/Coins

func setup(item_id: String, amount: int, type: RowType = RowType.INVENTORY):
	var item = ItemManagerAl.get_item(item_id)
	if item == null: push_warning("Item not fouond: " + item_id)
	
	item_icon.texture = item.icon_texture
	item_name.text = item.name
	item_amount.text = "x" + str(amount)
	
	match type:
		RowType.INVENTORY:
			item_price.hide()
			coin_icon.hide()
			apply_style(Color("b37e3f"))
		RowType.SHOP_BUY:
			if item.selling_price: item_price.text = str(item.selling_price)
			else: item_price.text = "//price not found//"
			item_price.show()
			coin_icon.show()
			apply_style(Color("ffffffff"), Color("36000075"))
		RowType.SHOP_SELL:
			item_price.text = "//not implemented//"
			item_price.show()
			coin_icon.show()

func apply_style(font_color: Color, bg_color: Color = Color("00000000"), border_color: Color = Color("00000000")):
	item_name.add_theme_color_override("font_color", font_color)
	item_amount.add_theme_color_override("font_color", font_color)
	item_price.add_theme_color_override("font_color", font_color)

	var style_box = StyleBoxFlat.new()
	style_box.bg_color = bg_color
	style_box.corner_radius_top_left = 4
	style_box.corner_radius_top_right = 4
	style_box.corner_radius_bottom_left = 4
	style_box.corner_radius_bottom_right = 4
	
	#style_box.border_color = border_color
	#style_box.border_width_left = 1
	#style_box.border_width_right = 1
	#style_box.border_width_top = 1
	#style_box.border_width_bottom = 1
	add_theme_stylebox_override("panel", style_box)
