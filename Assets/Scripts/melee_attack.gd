extends State

@onready var attack: AudioStreamPlayer2D = $"../../Attack"


func enter():
	super.enter()
	if not Global.is_player_dead:
		animation_player.play("Melee_attack")

func transition():
	if owner.direction.length() > 30:
		get_parent().change_state("Follow")
	elif Global.is_player_dead:
		get_parent().change_state("Idle")
