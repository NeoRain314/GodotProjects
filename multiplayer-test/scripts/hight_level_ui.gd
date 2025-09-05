extends Control
@onready var ip_address_input: LineEdit = $IpAddress_Input



func _on_server_button_pressed() -> void:
	if !ip_address_input.text:
		ip_address_input.add_theme_color_override("font_placeholder_color", "darkred")
		return
		
	print("start server")
	HightLevelNetworkHandler.IP_ADDRESS = ip_address_input.text
	HightLevelNetworkHandler.start_server()


func _on_client_button_pressed() -> void:
	if !ip_address_input.text:
		ip_address_input.add_theme_color_override("font_placeholder_color", "darkred")
		return
		
	HightLevelNetworkHandler.IP_ADDRESS = ip_address_input.text
	HightLevelNetworkHandler.start_client()
	print("join Client")
