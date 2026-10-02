extends State

@export var bullet_node: PackedScene
@onready var marker: Marker2D = $"../../Sprite2D/Marker2D"
var can_transition: bool = false


func enter():
	super.enter()
	animation_player.play("Ranged_attack")
	await animation_player.animation_finished
	shoot()
	can_transition = true

func shoot():
	var bullet = bullet_node.instantiate()
	bullet.position = marker.global_position
	get_tree().current_scene.add_child(bullet)

func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("Dash")
