extends State

@onready var pivot: Node2D = $"../../Pivot"
var can_transition: bool = false
@onready var laser_damage_area: Area2D = $"../../Pivot/Area2D"

func enter():
	super.enter()
	await play_animation("Laser_cast")
	await play_animation("Laser")
	can_transition = true

func play_animation(anim_name):
	animation_player.play(anim_name)
	await animation_player.animation_finished

func set_target():
	pivot.rotation = (owner.direction - pivot.position).angle()

func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("Dash")

func the_sun_is_a_deadly_laser():
	var overlapping_bodies = laser_damage_area.get_overlapping_bodies()
	for body in overlapping_bodies:
		if body == player:
			Global.damage_player(body)
			break
