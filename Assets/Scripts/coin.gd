extends Area2D

func _on_body_entered(body: Node2D) -> void :
	if body.has_method("player"):
		Global.score()
		Global.coinSFX()
		queue_free()
