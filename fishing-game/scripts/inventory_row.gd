extends PanelContainer

enum RowType {INVENTORY, INVENTORY_SHOP, YOUR_SHOP, GAME_SHOP }

var type
var item

var is_mouse_hovering: bool = false

@onready var item_icon = $HBoxContainer/Icon
@onready var item_name = $HBoxContainer/NameLabel
@onready var item_amount = $HBoxContainer/AmountLabel
@onready var item_price = $HBoxContainer/PriceLabel
@onready var coin_icon = $HBoxContainer/Coins

func setup(item_id: String, amount: int, row_type: RowType = RowType.INVENTORY):
	item = ItemManagerAl.get_item(item_id)
	if item == null: push_warning("Item not fouond: " + item_id)
	
	item_icon.texture = item.icon_texture
	item_name.text = item.name
	item_amount.text = "x" + str(amount)
	
	type = row_type
	match type:
		RowType.INVENTORY:
			item_price.hide()
			coin_icon.hide()
			apply_style(Color("b37e3f"))
		RowType.INVENTORY_SHOP:
			item_price.hide()
			coin_icon.hide()
			apply_style(Color("b37e3f"))
		RowType.YOUR_SHOP:
			if item.selling_price: item_price.text = str(item.selling_price)
			else: item_price.text = "//price not found//"
			item_price.show()
			coin_icon.show()
			apply_style(Color("ffffffff"), Color("36000075"))
		RowType.GAME_SHOP:
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

func _process(delta: float) -> void:
	if  Input.is_action_just_released("mouse_click") and is_mouse_hovering:
		match type:
			RowType.YOUR_SHOP: #get items back
				ShopManagerAl.remove_item(ShopManagerAl.your_shop, item.id, 1)	
				InventoryManagerAl.add_item(item.id)	
			RowType.GAME_SHOP: #buy items
				pass	 #buy		
			RowType.INVENTORY_SHOP: #put items in shop
				if item.can_be_sold():
					InventoryManagerAl.remove_item(item.id)	
					ShopManagerAl.add_item(ShopManagerAl.your_shop, item.id)	

func _on_mouse_entered() -> void:
	is_mouse_hovering = true
	match type:
		RowType.YOUR_SHOP:
			GameManagerAl.set_cursor(GameManagerAl.cursor_select, "get back")				
		RowType.GAME_SHOP:
			GameManagerAl.set_cursor(GameManagerAl.cursor_select, "buy")				
		RowType.INVENTORY_SHOP:
			if item.can_be_sold(): 	GameManagerAl.set_cursor(GameManagerAl.cursor_select, "put in shop")				


func _on_mouse_exited() -> void:
	is_mouse_hovering = false
	GameManagerAl.set_cursor(GameManagerAl.cursor_norm, "")
