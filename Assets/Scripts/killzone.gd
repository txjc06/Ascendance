extends Area2D


func _on_body_entered(body: Node2D) -> void :
	if body.has_method("player"):
		if not body.is_in_menu:
			Global.show_death_screen()
	elif body.has_method("enemy"):
		body.queue_free()
