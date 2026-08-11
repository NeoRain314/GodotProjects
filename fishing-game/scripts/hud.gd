extends Control

@export var inv_row_scene: PackedScene
@onready var inv_container = $Inventory/MarginContainer/ScrollContainer/VBoxContainer
@onready var inv_panel =  $Inventory

@onready var inv_button = $InventoryButton
@onready var inv_button_lable = $InventoryButton/Label
#inv_button textures:
var texture_inv_button = preload("res://assets/UI/buttons/inv_button.png")
var texture_inv_button_hover = preload("res://assets/UI/buttons/inv_button_hover.png")
var texture_closeinv_button = preload("res://assets/UI/buttons/inv_close_button.png")
var texture_closeinv_button_hover = preload("res://assets/UI/buttons/inv_close_button_hover.png")

var inventory_open: bool


func _ready() -> void:
	inv_panel.visible = false
	inventory_open = false
	inv_panel.pivot_offset = Vector2(inv_panel.size.x, 0)
	inv_button.pivot_offset = Vector2(inv_button.size.x, 0)
	
	
	InventoryManagerAl.inventory_changed.connect(update_inventory_ui) #connect so signal from inv manager
	update_inventory_ui()

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

func open_inventory():
	inv_panel.visible = true
	var tween = inv_panel.create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	inv_panel.scale = Vector2.ZERO
	tween.tween_property(inv_panel, "scale", Vector2.ONE, 0.3)
	inventory_open = true

func close_inventory():
	var tween = inv_panel.create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_property(inv_panel, "scale", Vector2.ZERO, 0.2)
	tween.tween_callback(inv_panel.hide)
	inventory_open = false

# --- old ---
#func update_inventory_ui():
	#var inv_text: String = "Inventory: \n"
	#for item_id in InventoryManagerAl.contents:
		#inv_text += "- " + item_id + ": " + str(InventoryManagerAl.contents[item_id]) + "\n"
	#$TempInventory.text = inv_text


func _on_inv_button_pressed() -> void:
	if inventory_open: 
		close_inventory()
		play_button_pop_texture_change(texture_inv_button, texture_inv_button_hover, true)
	else: 
		open_inventory()
		play_button_pop_texture_change(texture_closeinv_button, texture_closeinv_button_hover, false)

func set_inv_button_texture(norm_tex, hover_tex, show_lable: bool):
	inv_button.texture_normal = norm_tex
	inv_button.texture_hover = hover_tex
	inv_button.texture_pressed = hover_tex
	inv_button_lable.visible = show_lable
	
func play_button_pop_texture_change(norm_tex, hover_tex, show_lable: bool):
	
	var tween = inv_button.create_tween()
	
	# 1. Scale down to zero (Shrink)
	tween.tween_property(inv_button, "scale", Vector2.ZERO, 0.15)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN)
	
	# 2. Swap texture while it's invisible
	tween.tween_callback(func(): set_inv_button_texture(norm_tex, hover_tex, show_lable))
	
	# 3. Scale back to normal with a pop/bounce effect
	tween.tween_property(inv_button, "scale", Vector2.ONE, 0.25)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)
