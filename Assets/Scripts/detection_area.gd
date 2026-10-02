extends Area2D


@onready var camera: = %Player.get_node("Camera")


func _on_body_entered(body: Node2D) -> void :
	if body.has_method("player"):
		camera.limit_bottom = 13432
		Dialogic.start("shit")
