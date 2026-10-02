extends Area2D





func _on_body_entered(body: Node2D) -> void :
	Dialogic.start("Seems_easy")
	set_deferred("monitoring", false)
