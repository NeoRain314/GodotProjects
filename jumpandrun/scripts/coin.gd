extends Area2D

@onready var game_manager: Node = %GameManager
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player_1: CharacterBody2D = $"../../Player1"



func _on_body_entered(body: Node2D) -> void:
	game_manager.add_point()
	body.add_point()
	animation_player.play("pickup")
