extends Area2D

const GUN = preload("res://Assets/Scenes/gun.tscn")
@onready var player: CharacterBody2D = %Player
@onready var pickup: AudioStreamPlayer2D = $"../Pickup"



func _on_body_entered(body: Node2D) -> void :
	if body.has_method("player"):
		pickup.play()
		var gun_instance = GUN.instantiate()
		get_parent().find_child("Player").add_child(gun_instance)
		gun_instance.position = player.gun_position.position
		queue_free()
