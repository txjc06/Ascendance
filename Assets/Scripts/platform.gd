extends AnimatableBody2D

@onready var elevator: AudioStreamPlayer2D = $Elevator

var is_first_play: = true




func _on_funky_zone_body_entered(body: Node2D) -> void :
	if body.has_method("player"):
		if is_first_play:
			elevator.play(Global.song_position)
			Global.Background_SFX(false)
			is_first_play = false
		elif not is_first_play:
			elevator.stream_paused = false
			Global.Background_SFX(false)

func _on_funky_zone_body_exited(body: Node2D) -> void :
	if body.has_method("player"):
		elevator.stream_paused = true
		Global.Background_SFX(true)
		Global.song_position = elevator.get_playback_position()
