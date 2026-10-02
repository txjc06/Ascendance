extends Area2D

@onready var transition_node: Node2D = %TransitionNode
@onready var transition_node_anim: = transition_node.find_child("AnimationPlayer")


func _on_body_entered(body: Node2D) -> void :
	if body.has_method("player"):
		Global.collected_coins_previous = Global.collected_coins
		Global.current_level = 3
		transition_node.visible = true
		transition_node_anim.play("Fade_out")
		await transition_node_anim.animation_finished
		get_tree().change_scene_to_file("res://Assets/Scenes/Area/The_Underground_lvl3.tscn")
