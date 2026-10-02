extends Area2D

@onready var camera: = %Player.get_node("Camera") as Camera2D
@onready var player: = %Player as CharacterBody2D

func _on_body_entered(body: Node2D) -> void :
	if body.has_method("player"):
		camera.limit_bottom = 10600
		camera.position_smoothing_enabled = false
		player.can_jump_special = false
