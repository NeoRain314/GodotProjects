extends Node

var items: Dictionary = {}

var rod_catchable_items: Array = []
var net_catchable_items: Array = []

# upgradable items #
var tierlist_fishing_rod: Array = ["test_rod", "test_net", "test_rod", "test_net"]
var curr_tier_fishing_rod: int = 0


func _ready() -> void:
	load_items_from_dir("res://resources/Items/")
	if rod_catchable_items.is_empty(): push_warning("Rod Catchable Items emoty")
	if net_catchable_items.is_empty(): push_warning("Net Catchable Items emoty")
	print(items)

func load_items_from_dir(path: String):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir() && not file_name.begins_with("."):
				load_items_from_dir(path + file_name + "/")
			elif file_name.ends_with(".tres") or file_name.ends_with(".remap"):
				var resource_path = path + file_name.replace(".remap", "")
				var item = load(resource_path) as ItemData
				if item && item.id != "":
					items[item.id] = item
					if(item.can_be_catched_by_rod()): rod_catchable_items.append(item.id)
					if(item.can_be_catched_by_net()): net_catchable_items.append(item.id) 
					#print(item.id)
			file_name = dir.get_next()

func get_item(id: String) -> ItemData:
	if items.has(id):
		return items[id]
		push_warning("Item ID not found: " + id)
	return null
