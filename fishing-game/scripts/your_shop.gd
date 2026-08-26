extends Node

signal change_scene_request(scene)

func _on_button_start_trip_pressed() -> void:
	change_scene_request.emit(GameManagerAl.scene_boat_trip)
