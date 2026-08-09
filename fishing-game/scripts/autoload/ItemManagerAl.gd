extends Node

var items: Dictionary = {}

func _ready() -> void:
	load_items_from_dir("res://resources/Items/")

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
					print(item.id)
			file_name = dir.get_next()

func get_item(id: String) -> ItemData:
	if items.has(id):
		return items[id]
		push_warning("Item ID not found: " + id)
	return null
