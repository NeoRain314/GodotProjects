extends Control

@export var type = ""

@onready var icon = $TextureRect2/Icon
@onready var price_label = $TextureRect2/Price
@onready var button = $TextureRect2/Button

var next_item_id = ""
var next_item_tier = 1

var player_curr_tier: Dictionary = { #list of all the tier the player has of all items
	"Fishing Rod": ItemManagerAl.curr_tier_fishing_rod
}

var tier_list: Dictionary = { #list that contains all tier lists of each item
	"Fishing Rod": ItemManagerAl.tierlist_fishing_rod
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_card()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func update_card():
	next_item_id = tier_list["Fishing Rod"][next_item_tier]
	var item = ItemManagerAl.get_item(next_item_id)
	icon.texture = item.icon_texture
	price_label.text = str(item.unlock_price)
	if next_item_tier == 0:
		button.text = "unlock"
	else: button.text = "upgrade to Level " + str(next_item_tier)
	
	if next_item_tier == tier_list["Fishing Rod"].size()-1:
		button.text = "max"
		button.disabled = true
	
	
	print("next item to unlock: " + next_item_id)
	print("current player item: " + tier_list["Fishing Rod"][next_item_tier-1])


func _on_button_pressed() -> void:
	var item = ItemManagerAl.get_item(next_item_id)
	if next_item_tier < tier_list["Fishing Rod"].size()-1 and GameManagerAl.g_coins >= item.unlock_price:
		next_item_tier += 1
		GameManagerAl.g_coins -= item.unlock_price
		update_card()
		
