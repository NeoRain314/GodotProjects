class_name ItemData
extends Resource

@export var id: String = ""
@export var name: String
@export var texture: Texture2D = load("res://assets/Item Icons/TextureNotFond.png")
@export var icon_texture: Texture2D = load("res://assets/Item Icons/TextureNotFond.png")
@export var weight : float
@export var selling_price: int

@export_flags("Rod Catchable:1", "Net Catchable:2", "Sellable:4") var tags: int = 0

func can_be_catched_by_rod() -> bool:
	return (tags & 1) != 0
	
func can_be_catched_by_net() -> bool:
	return (tags & 2) != 0

func can_be_sold() -> bool:
	return (tags & 4) != 0
