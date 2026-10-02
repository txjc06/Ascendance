extends Area2D



func _on_body_entered(body: Node2D) -> void :
	if body.has_method("player"):
		Dialogic.start("Not_again")
		set_deferred("monitoring", false)
		Global.Background_SFX(false)
