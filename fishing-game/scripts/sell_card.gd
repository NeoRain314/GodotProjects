extends Control

@export var type = ""

@onready var icon = $TextureRect2/Icon
@onready var price_label = $TextureRect2/Price
@onready var button = $TextureRect2/Button

var curr_item_id = ""
var curr_item_tier = 0

var curr_tier: Dictionary = {
	"Fishing Rod": ItemManagerAl.curr_tier_fishing_rod
}

var tier_list: Dictionary = {
	"Fishing Rod": ItemManagerAl.tierlist_fishing_rod
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_card()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func update_card():
	curr_item_id = tier_list["Fishing Rod"][curr_item_tier]
	var item = ItemManagerAl.get_item(curr_item_id)
	icon.texture = item.icon_texture
	price_label.text = str(item.upgrade_price)
	if curr_item_tier == 0:
		button.text = "unlock"
	else: button.text = "upgrade"
	
	if curr_item_tier == tier_list["Fishing Rod"].size()-1:
		button.text = "max"
		button.disabled = true


func _on_button_pressed() -> void:
	var item = ItemManagerAl.get_item(curr_item_id)
	if curr_item_tier < tier_list["Fishing Rod"].size()-1 and GameManagerAl.g_coins >= item.upgrade_price:
		curr_item_tier += 1
		GameManagerAl.g_coins -= item.upgrade_price
		update_card()
		
