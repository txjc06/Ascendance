extends Area2D

@onready var sprite_2d: Sprite2D = $Sprite2D
var direction: = Vector2.ZERO


func _on_body_entered(body: Node2D) -> void :
	if body.has_method("player") and not Global.is_player_dead:
		Global.damage_player(body)
		queue_free()
