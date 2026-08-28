extends Control

@onready var icon = $TextureRect2/Icon
@onready var price_label = $TextureRect2/Price
@onready var button = $TextureRect2/Button

@export var type = ""
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
	curr_item_id = tier_list["Fishing Rod"][curr_item_tier]
	update_card()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func update_card():
	var item = ItemManagerAl.get_item(curr_item_id)
	icon.texture = item.icon_texture
	price_label.text = str(item.upgrade_price)
